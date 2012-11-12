class WorkflowsController < ApplicationController
  before_filter :load_status, :load_operators, :load_type_field

  # GET /workflows
  # GET /workflows.json
  def index
    @workflows_grid = initialize_grid(Workflow, :conditions=>["account_id = ?", session[:account_id]],
                                        :name=>'workflows',
                                        :enable_export_to_csv => true,
                                        :csv_field_separator => ';',
                                        :csv_file_name=>'workflows'
                                        )
    
    @breadcumb = [{:caminho=>'home', :exibicao=>'Home'}, {:caminho=>'workflows', :exibicao=>'workflows'}]
    @tabsval = [{:caminho=>'workflows', :exibicao=>'Listar',:active=>true, :icon=>'icon-th-list' }, {:caminho=>'workflows/new', :exibicao=>'Novo', :active=>false, :icon=>'icon-plus'}, 
                {:caminho=>'workflows/history', :exibicao=>'Historico', :active=>false, :icon=>'icon-book'}]
    export_grid_if_requested('workflows'=>'workflows_grid')
  end

  # GET /workflows/1
  # GET /workflows/1.json
  def show
    @workflow = Workflow.find_by_id_and_account_id(params[:id], session[:account_id])
    if @workflow.nil?
        flash[:error] = 'Workflow nao encontrado para esta conta.'
    else
      @breadcumb = [{:caminho=>'home', :exibicao=>'Home'}, {:caminho=>'workflows', :exibicao=>'workflows'}, 
                    {:caminho=>"workflows/#{@workflow.id}", :exibicao=>@workflow.id}]
      @tabsval = [{:caminho=>'workflows', :exibicao=>'Listar',:active=>false, :icon=>'icon-th-list' },
                  {:caminho=>"workflows/#{@workflow.id}", :exibicao=>'Mostrar', :active=>true, :icon=>'icon-info-sign'},
                  {:caminho=>"workflows/#{@workflow.id}/edit", :exibicao=>'Editar', :active=>false, :icon=>'icon-pencil'},
                  {:caminho=>'workflows/new', :exibicao=>'Novo', :active=>false, :icon=>'icon-plus'},
                  {:caminho=>'workflows/history', :exibicao=>'Historico', :active=>false, :icon=>'icon-book'},
                  {:caminho=>"workflows/send_out/#{@workflow.id}", :exibicao=>'Comunicacao', :active=>false, :icon=>'icon-globe'}]
    end    
    respond_to do |format|
        format.html { redirect_to :action=>'index'} if @workflow.nil?
        format.html # show.html.erb
        format.json { render json: @workflow }
    end
  end

  # GET /workflows/new
  # GET /workflows/new.json
  def new
    @workflow = Workflow.new
    @breadcumb = [{:caminho=>'home', :exibicao=>'Home'}, {:caminho=>'workflows', :exibicao=>'workflows'}, 
                  {:caminho=>"workflows/new/", :exibicao=>'Novo'}]
    @tabsval = [{:caminho=>'workflows', :exibicao=>'Listar',:active=>false, :icon=>'icon-th-list' },
                {:caminho=>'workflows/new', :exibicao=>'Novo', :active=>true, :icon=>'icon-plus'},
                {:caminho=>'workflows/history', :exibicao=>'Historico', :active=>false, :icon=>'icon-book'} ]
    1.times { @workflow.rules.build }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @workflow }
    end
  end

  # GET /workflows/1/edit
  def edit
    @workflow = Workflow.find_by_id_and_account_id(params[:id], session[:account_id])
    if @workflow.nil?
      flash[:error] = 'Workflow nao encontrado para esta conta.'
      respond_to do |format|
        format.html { redirect_to :action=>'index'}
      end
    else
      @breadcumb = [{:caminho=>'home', :exibicao=>'Home'}, {:caminho=>'workflows', :exibicao=>'workflows'}, 
                    {:caminho=>"workflows/#{@workflow.id}/edit/", :exibicao=>'Editar'}, {:caminho=>"workflows/#{@workflow.id}", :exibicao=>@workflow.id}]
      @tabsval = [{:caminho=>"workflows/#{@workflow.id}", :exibicao=>'Mostrar',:active=>false, :icon=>'icon-info-sign' }, {:caminho=>"workflows/#{@workflow.id}/edit", :exibicao=>'Edit', :active=>true, :icon=>'icon-pencil'}, 
                  {:caminho=>'workflows/history', :exibicao=>'Historico', :active=>false, :icon=>'icon-book'},
                  {:caminho=>"workflows/send_out/#{@workflow.id}", :exibicao=>'Comunicacao', :active=>false, :icon=>'icon-globe'} ]
    end
    
  end

  # POST /workflows
  # POST /workflows.json
  def create
    
    account = {}
    account = {:account_id => session[:account_id]}
    params[:workflow].merge!(account)
    retorno = data_validation(:data1=>params[:workflow]["date_start"], :data2=>params[:workflow]["date_finish"])
    @workflow = Workflow.new(params[:workflow])
    respond_to do |format|
      if !retorno
        @breadcumb = [{:caminho=>'home', :exibicao=>'Home'}, {:caminho=>'workflows', :exibicao=>'workflows'}, 
                    {:caminho=>"workflows/new/", :exibicao=>'Novo'}]
          @tabsval = [{:caminho=>'workflows', :exibicao=>'Listar',:active=>false, :icon=>'icon-th-list' },
                      {:caminho=>'workflows/new', :exibicao=>'Novo', :active=>true, :icon=>'icon-plus'},
                      {:caminho=>'workflows/history', :exibicao=>'Historico', :active=>false, :icon=>'icon-book'} ]
        flash[:error] = 'Datas do Workflow invalidas. A data final deve ser maior que a data inicial'
          format.html { render action: "new"}
      else
        if @workflow.save
          Rails.logger.add_metadata({:user_id =>current_user.id,
                                     :acoes=>"<em>criado o workflow de id #{@workflow.id}</em>",
                                     :ipvalue=>request.remote_ip, :time=>Time.now}) if Rails.logger.respond_to?(:add_metadata)
          action_rep = get_action(params[:sub], @workflow.id)
          flash[:success] = 'Workflow criado com sucesso!'
          format.html { redirect_to :action=>action_rep}
          
          format.json { render json: @workflow, status: :created, location: @workflow }
          
        else
          flash.now[:error] = 'Workflow was not created.'
          @breadcumb = [{:caminho=>'home', :exibicao=>'Home'}, {:caminho=>'workflows', :exibicao=>'workflows'}, 
                    {:caminho=>"workflows/new/", :exibicao=>'Novo'}]
          @tabsval = [{:caminho=>'workflows', :exibicao=>'Listar',:active=>false, :icon=>'icon-th-list' },
                      {:caminho=>'workflows/new', :exibicao=>'Novo', :active=>true, :icon=>'icon-plus'},
                      {:caminho=>'workflows/history', :exibicao=>'Historico', :active=>false, :icon=>'icon-book'} ]
          format.html { render action: "new" }
          format.json { render json: @workflow.errors, status: :unprocessable_entity }
        end
       end
    end
  end

  # PUT /workflows/1
  # PUT /workflows/1.json
  def update
    @workflow = Workflow.find_by_id_and_account_id(params[:id], session[:account_id])
    retorno = data_validation(:data1=>params[:workflow]["date_start"], :data2=>params[:workflow]["date_finish"])
    respond_to do |format|
      if @workflow.nil?
        flash[:error] = 'Workflow nao encontrado para esta conta.'
        format.html { redirect_to :action=>'index'}
      else
        if !retorno
          flash[:error] = 'Datas do Workflow invalidas. A data final deve ser maior que a data inicial'
          format.html { redirect_to :action=>'edit'}
        else
          if @workflow.update_attributes(params[:workflow])
            Rails.logger.add_metadata({:user_id =>current_user.id,
                                       :acoes=>"<em>alterado o workflow de id #{@workflow.id}</em>",
                                       :ipvalue=>request.remote_ip, :time=>Time.now}) if Rails.logger.respond_to?(:add_metadata)
            
            action_rep = get_action(params[:sub], @workflow.id)
            flash[:success] = 'Workflow atualizado com sucesso!'
            format.html { redirect_to :action=>action_rep}
            format.json { head :no_content }
          else
            format.html { render action: "edit" }
            format.json { render json: @workflow.errors, status: :unprocessable_entity }
          end
         end
       end
    end
  end

  # DELETE /workflows/1
  # DELETE /workflows/1.json
  def destroy
    @workflow = Workflow.find_by_id_and_account_id(params[:id], session[:account_id])
    if @workflow.nil?
        respond_to do |format|
          flash[:error] = 'Workflow nao encontrado para esta conta.'
          format.html { redirect_to :action=>'index'}
        end
    else
      @workflow.destroy
      flash[:success] = 'Workflow excluido com sucesso.'
      Rails.logger.add_metadata({:user_id =>current_user.id,
                                     :acoes=>"<em>removido o workflow de id #{params[:id]}</em>",
                                     :ipvalue=>request.remote_ip, :time=>Time.now}) if Rails.logger.respond_to?(:add_metadata)
      respond_to do |format|
        format.html { redirect_to workflows_url }
        format.json { head :no_content }
      end
    end
  end
  
  def history
    @breadcumb = [{:caminho=>'home', :exibicao=>'Home'}, {:caminho=>'workflows', :exibicao=>'workflows'}, {:caminho=>"workflows/history/", :exibicao=>'historico'}]
    @tabsval = [{:caminho=>'workflows', :exibicao=>'Listar',:active=>false, :icon=>'icon-th-list' }, {:caminho=>'workflows/new', :exibicao=>'Novo', :active=>false, :icon=>'icon-plus'}, 
         {:caminho=>'workflows/history', :exibicao=>'Historico', :active=>true, :icon=>'icon-book'} ]
    @logs = {}
    
    db = Rails.logger.mongo_connection
    collection = db[Rails.logger.mongo_collection_name]    
    @logs[:update] = collection.find({:user_id=>current_user.id, "controller"=>"workflows", "action"=>'update'})  
    @logs[:insert] = collection.find({:user_id=>current_user.id, "controller"=>"workflows", "action"=>'create'})
    @logs[:destroy] = collection.find({:user_id=>current_user.id, "controller"=>"workflows", "action"=>'destroy'})
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @logs }
    end
  end
    
  def send_out
    @workflow = Workflow.find_by_id_and_account_id(params[:id], session[:account_id])
    if @workflow.nil?
        respond_to do |format|
          flash[:error] = 'Workflow nao encontrado para esta conta.'
          format.html { redirect_to :action=>'index'}
        end
    else
      @breadcumb = [{:caminho=>'home', :exibicao=>'Home'}, {:caminho=>'workflows', :exibicao=>'workflows'}, {:caminho=>"workflows/#{@workflow.id}/send_out/", :exibicao=>'comunicacao'}]
      @tabsval = [{:caminho=>"workflows/#{@workflow.id}", :exibicao=>'Mostrar',:active=>false, :icon=>'icon-info-sign' }, {:caminho=>"workflows/#{@workflow.id}/edit", :exibicao=>'Edit', :active=>false, :icon=>'icon-pencil'}, 
                  {:caminho=>'workflows/history', :exibicao=>'History', :active=>false, :icon=>'icon-book'},
                  {:caminho=>"workflows/send_out/#{@workflow.id}", :exibicao=>'Comunicacao', :icon=>'icon-globe', :active=>true} ]
      @account = Account.first(:conditions=>{:user_id=>current_user.id})
      load_workflow_config_send
    end
  end
  
  def save_comunication
    
    unless params[:workflow_config_sends][:workflow_id].nil?
      workflow = Workflow.find_by_id_and_account_id(params[:workflow_config_sends][:workflow_id], session[:account_id])  
      Sendmail.clear_data(workflow.id)
      Sendsm.clear_data(workflow.id)
    end
    
    unless params[:workflow_config_sends][:send_mail].blank?
      Rails.logger.add_metadata({:workflow_id=>workflow.id})
      
      params[:workflow_config_sends][:send_mail][:email_id].each do |email|
        emails = Sendmail.new(:email_id=>email, :workflow_id=>workflow.id)
        emails.save
      end
         Rails.logger.add_metadata({:user_id =>current_user.id,
                                     :acoes=>"<em>criada a comunicacao de emails para o workflow #{workflow.name}</em>",
                                     :ipvalue=>request.remote_ip, :time=>Time.now}) if Rails.logger.respond_to?(:add_metadata)
      
    end
    unless params[:workflow_config_sends][:send_sms].blank?
      
      params[:workflow_config_sends][:send_sms][:sm_id].each do |sms|
        sms = Sendsm.new(:sm_id=>sms, :workflow_id=>workflow.id)
        sms.save
      end
        Rails.logger.add_metadata({:user_id =>current_user.id,
                                     :acoes=>"<em>criada a comunicacao de sms para o workflow #{workflow.name}</em>",
                                    :ipvalue=>request.remote_ip, :time=>Time.now}) if Rails.logger.respond_to?(:add_metadata)
      
    end
    flash[:success] = I18n.t('workflow.mensagens.send_save_success')
    respond_to do |format|
      format.html { redirect_to :action=>"send_out/#{workflow.id}"}      
    end
    
  end

protected
  def load_status
    @status = Status.where("id IN (?)",[Status::ATIVO, Status::INATIVO]).collect{|s|[s.name, s.id]}
  end
  def load_operators
    @operators = Operator.all.collect{ |p| [p.name, p.id]}
  end
  
  def load_workflow_config_send
    @emails_cad = Sendmail.where('workflow_id = ?', @workflow.id)
    @sms_cad = Sendsm.where('workflow_id = ? ', @workflow.id)
    @emails = Email.where("status_id = ? AND account_id = ?", Status::ATIVO, session[:account_id])
    @sms = Sm.where("status_id = ? AND account_id = ?", Status::ATIVO, session[:account_id]) 
  end
  
  def load_type_field
    @type_fields = TypeField.all.collect{|t| [t.name, t.id]}
  end
  
private
  def data_validation(options={})
    if options[:data1].blank?
      return false
    end
    if options[:data2].blank?
      return true
    end
    if options[:data1].to_date > options[:data2].to_date
      return false
    else
      return true
    end
  end
end
