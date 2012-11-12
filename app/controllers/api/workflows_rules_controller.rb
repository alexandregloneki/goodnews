class Api::WorkflowsRulesController < ApplicationController
  before_filter :restrict_access 
  skip_before_filter :authenticate_user!
  JSON_ROOT = 'workflow_rules'
  include WorkflowsRulesHelper 
  

  def send_data
    
    data_response = {}
    general_errors = {}
    validation_errors = {}
    workflows = nil
    
    begin
    
      raise 'Conta nao encontrada ou status da conta inadimplente' if @account.nil?
      workflows = Workflow.where('account_id = ? AND status_id =  ?', @account.id, Status::ATIVO)
      comunicacao = []
      data_error = []
      data_response = []
      unless workflows.blank?
        workflows.each do |workflow|
          retorno_rules = verify_rules(workflow, params)
          
          if retorno_rules[:success]
            comunicacao << send_comunication(workflow, @account)
          else
            retorno_rules.merge!(:workflow=>workflow)
            data_error << get_error_workflow(retorno_rules)
          end
          
        end
        
      else
        raise 'Nao foram encontrados workflows ativos spara esta conta'  
      end 
    rescue Exception => e
      general_errors[:message] =e.message 
    end
    return respond_to_json(:general_errors=>general_errors, :object=>workflows, :notification=>comunicacao, :root=>JSON_ROOT, :data_error=>data_error)
    
  end
  
  def verify_rules(workflow, params)
    
    return :date=>true, :success=>false unless verify_date?(workflow)
    return :qtd_rules=>true, :success=>false unless verify_rules_qtd?(params[:workflow_rules].count, workflow.rules.count)
    workflow.rules.each do |rule|
      return :rule_out=>true, :success=>false unless verify_rule_entry?(rule, params[:workflow_rules])
    end
    return :success=>true
  end
  
  def send_comunication(workflow, account)
    sms_envio = []
    email_envio = []
    mails_send = Sendmail.where('workflow_id = ?', workflow.id)
    sms_send = Sendsm.where('workflow_id = ?', workflow.id)  
    if sms_send.blank? && mails_send.blank?
      raise "Nao existem comunicacoes cadastradas para este workflow de nome [#{workflow.name}]"
    else
      sms_envio = send_sms_workflow(sms_send, workflow, account)
      email_envio = send_mails_workflow(mails_send, workflow, account)
    end
    return {:sms_envio=>sms_envio, :email_envio=>email_envio}
  end
  
  def send_sms_workflow(sms, workflow, account)
    retorno_sms = []
    unless sms.blank?
      sms.each do |sm|
        sms_env = Sm.first(:conditions=>{:id=>sm.sm_id, :status_id=>Status::ATIVO})
        Sm.send_sms(sm.sm_id)
        unless sms_env.nil?
          #Envio de SMS
          notification = Notification.new(:workflow_id=>workflow.id, :account_id=>account.id)
          if notification.save
            smsnotification = Smsnotification.new(:notification_id=>notification.id, :sm_id=>sms_env.id)
            smsnotification.save
          end
        end
        retorno_sms << sm
      end
    end
    return retorno_sms
  end
  
  def send_mails_workflow(mails, workflow, account)
    retorno = []
    unless mails.blank? 
      mails.each do |mail|
        email = Email.first(:conditions=>{:id=>mail.email_id, :status_id=>Status::ATIVO})
        unless email.nil?
          Notify.send_email(email).deliver
          notification = Notification.new(:workflow_id=>workflow.id, :account_id=>account.id)
          if notification.save
            emailnotification = Emailnotification.new(:notification_id=>notification.id, :email_id=>email.id)
            emailnotification.save
          end
        end
      
      retorno << mail
      end 
    end
    
    return retorno
  end
  
  
  def verify_rules_qtd?(qtd, workflow_rules_qtd)
    
    return true if qtd > workflow_rules_qtd
    return false if workflow_rules_qtd > qtd
    return true if qtd == workflow_rules_qtd
  end
  
  def verify_date?(workflow)
    if workflow.date_finish >= Date.today && workflow.date_start <= Date.today
      return true
    else
      return false  
    end    
  end

  def verify_rule_entry?(rule, receive)
    retorno = []
    receive.each_with_index do |rec, idx|
      
      ret = {}
      rece = rec.second
      if rece['field_reference'] == rule.field_references
         ret[:field_references] = true
      else
         ret[:field_references] = false 
      end
      
      if rece['field_comparation']== rule.field_comparation
        ret[:field_comparation]=true
      else
        ret[:field_comparation]=false
      end
      
      if "#{rece['value_comparation']}.#{rule.type_field.simbol} "      
        eval "if \'#{rece['value_comparation']}\'.#{rule.type_field.simbol} #{rule.operator.simbol} '#{rule.value_comparation}'.#{rule.type_field.simbol}  
              ret[:value_comparation]= true 
           else 
             ret[:value_comparation] = false
           end"
      else
        ret[:value_comparation] = false
      end
      
      retorno << ret
      
   end
   
   retorno.each do |saida|
     return true if saida[:field_references] && saida[:field_comparation] && saida[:value_comparation] 
   end
   return false 
  end
  
 private
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      Account.valid_user?(token)
      @account = Account.find_by_token_access(token)
    end
  end
  
end