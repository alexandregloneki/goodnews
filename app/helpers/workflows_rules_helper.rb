module WorkflowsRulesHelper

  def respond_to_json(options={})
    retorno = {}
    response = {}
    response[options[:root]] = []
    
    unless options[:object].nil?
      options[:object].each_with_index do |workflow, idx|
        success = false
        response_new = {}
        response_new[:workflow] = []
        
        ##all data workflow
        all_data = {}
        all_data[:general_data] = {}
        all_data[:general_data][:id] = workflow.id
        all_data[:general_data][:name] = workflow.name
        all_data[:general_data][:date_start] = workflow.date_start
        all_data[:general_data][:date_finish] = workflow.date_finish
        all_data[:general_data][:rules] = []
        workflow.rules.each do |rule|
          data = {}
          data[:field_references] = rule.field_references
          data[:field_comparation] = rule.field_comparation
          data[:value_comparation] = rule.value_comparation
          data[:operator] = rule.operator.name
          all_data[:general_data][:rules] << data
        end
        response_new[:workflow] << all_data
        
        #data error
        unless options[:data_error].nil?
          options[:data_error].each do |error|
            if error[:workflow].id == workflow.id
              all_error = {}
              all_error[:data_erros] = error[:mensagem]
              success = false
              response_new[:workflow] << all_error
            end
          end
        end
        
        #data notification
        unless options[:notification].blank?
          options[:notification].each do |data_ret|
            #if data_ret[:workflow][:id] == workflow.id
            
              all_data = {}
              all_data[:notification]  = {}
              if !data_ret[:email_envio].blank? 
                all_data[:notification][:email] = []
                data_ret[:email_envio].each do |email_env|
                  if email_env[:workflow_id] == workflow.id
                    objeto_email = Email.find(email_env[:email_id])
                    retorno_objeto = {}
                    retorno_objeto[:id] = objeto_email.id
                    retorno_objeto[:title] = objeto_email.title
                    retorno_objeto[:to] = objeto_email.to
                    retorno_objeto[:cc] = objeto_email.cc
                    retorno_objeto[:cco] = objeto_email.cco
                    all_data[:notification][:email] << retorno_objeto
                    success = true
                  end
                end
                
              end
             
              if !data_ret[:sms_envio].blank? 
                all_data[:notification][:sms] = []
                data_ret[:sms_envio].each do |sms_env|
                  if sms_env[:workflow_id] == workflow.id
                    objeto_sms = Sm.find(sms_env[:sm_id])
                    filtro = []
                    escolhidos = {}
                    escolhidos[:number_dispatch] =  objeto_sms.number_dispatch
                    filtro << escolhidos
                    all_data[:notification][:sms] << filtro
                    success = true
                  end
                end
                
              end
              response_new[:workflow] << all_data
              all_success = {}
              all_success[:success] = success
              response_new[:workflow] << all_success
          end
        end    
        response[options[:root]] << response_new
      end
    
    unless options[:general_errors].blank?
      general_error = {}
      general_error[:general_errors] = options[:general_errors]
      response[options[:root]] << general_error 
    end
  end
    render :json =>response
  end
  
  def get_data_response_workflow(regras = {})
    workflow = []
    retorno = {}
    regras[:regras].each do |regra|
      
      retorno[:workflow] = {}
      retorno[:workflow][:id] = regra.id
      retorno[:workflow][:name] = regra.name
      retorno[:workflow][:date_start] = regra.date_start
      retorno[:workflow][:date_finish] = regra.date_finish
      regra.rules.each do |rule|
        retorno[:workflow][:rules] = {}
        retorno[:workflow][:rules][:field_references] = rule.field_references
        retorno[:workflow][:rules][:field_comparation] = rule.field_comparation
        retorno[:workflow][:rules][:value_comparation] = rule.value_comparation
        retorno[:workflow][:rules][:operator] = rule.operator.name
      end
       
      workflow << retorno 
    end
    return workflow 
  end
  
  def get_error_workflow(errors = {})
    retorno = {}
    retorno[:mensagem] = []
    retorno[:mensagem] << 'Workflow verificado fora da data de validacao' if errors[:date].present?
    retorno[:mensagem] << 'Workflow verificado com quantidades de regras insuficiente' if errors[:qtd_rules].present?
    retorno[:mensagem] << 'Workflow verificado nao se enquadra nas regras enviadas' if errors[:rule_out].present?
    retorno[:workflow] = errors[:workflow]
    return retorno
  end
  
end