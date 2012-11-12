class EmailsController < ApplicationController
  # GET /Emails
  # GET /Emails.json
  before_filter :load_status 
  def index
    
    @emails_grid = initialize_grid(Email, :conditions=>["account_id = ?", session[:account_id]],
                                        :name=>'emails',
                                        :enable_export_to_csv => true,
                                        :csv_field_separator => ';',
                                        :csv_file_name=>'emails'
                                        )
    @breadcumb = [{:caminho=>'home', :exibicao=>I18n.t('application.titulos.home')}, {:caminho=>'emails', :exibicao=>'emails'}]
    @tabsval = [{:caminho=>'emails', :exibicao=>I18n.t('application.titulos.index'),:active=>true, :icon=>'icon-th-list' }, {:caminho=>'emails/new', :exibicao=>I18n.t('application.titulos.new'), :active=>false, :icon=>'icon-plus'}, 
                {:caminho=>'emails/history', :exibicao=>I18n.t('application.titulos.history'), :active=>false, :icon=>'icon-book'} ]
       
    export_grid_if_requested('emails'=>'emails_grid')    
  end

  # GET /Emails/1
  # GET /Emails/1.json:
  def show
    @email = Email.find_by_id_and_account_id(params[:id], session[:account_id])
    if @email.nil?
        flash[:error] = I18n.t('email.mensagens.not_found_account')
    else
      @breadcumb = [{:caminho=>'home', :exibicao=>I18n.t('application.titulos.home')}, {:caminho=>'emails', :exibicao=>'emails'}, 
                    {:caminho=>"emails/#{@email.id}", :exibicao=>@email.id}]
      @tabsval = [{:caminho=>'emails', :exibicao=>I18n.t('application.titulos.index'),:active=>false, :icon=>'icon-th-list' },
                  {:caminho=>"emails/#{@email.id}", :exibicao=>I18n.t('application.titulos.show'), :active=>true, :icon=>'icon-info-sign'},
                  {:caminho=>"emails/#{@email.id}/edit", :exibicao=>I18n.t('application.titulos.edit'), :active=>false, :icon=>'icon-pencil'},
                  {:caminho=>'emails/new', :exibicao=>I18n.t('application.titulos.new'), :active=>false, :icon=>'icon-plus'},
                  {:caminho=>'emails/history', :exibicao=>I18n.t('application.titulos.history'), :active=>false, :icon=>'icon-book'} ]
    end
    respond_to do |format|
      format.html { redirect_to :action=>'index'} if @email.nil?
      format.html # show.html.erb
      format.json { render json: @email }
    end
  end

  # GET /Emails/new
  # GET /Emails/new.json
  def new
    @email = Email.new
    @breadcumb = [{:caminho=>'home', :exibicao=>I18n.t('application.titulos.home')}, {:caminho=>'emails', :exibicao=>'emails'}, 
                  {:caminho=>"emails/new/", :exibicao=>I18n.t('application.titulos.new')}]
    @tabsval = [{:caminho=>'emails', :exibicao=>I18n.t('application.titulos.show'),:active=>false, :icon=>'icon-th-list' },
                {:caminho=>'emails/new', :exibicao=>I18n.t('application.titulos.new'), :active=>true, :icon=>'icon-plus'},
                {:caminho=>'emails/history', :exibicao=>I18n.t('application.titulos.history'), :active=>false, :icon=>'icon-book'} ]
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @email }
    end
  end

  # GET /Emails/1/edit
  def edit
    @email = Email.find_by_id_and_account_id(params[:id], session[:account_id])
    if @email.nil?
      flash[:error] = I18n.t('email.mensagens.not_found_account')
      respond_to do |format|
        format.html { redirect_to :action=>'index'}
      end
    else
      @breadcumb = [{:caminho=>'home', :exibicao=>I18n.t('application.titulos.home')}, {:caminho=>'emails', :exibicao=>'emails'}, 
                    {:caminho=>"emails/#{@email.id}/edit/", :exibicao=>I18n.t('application.titulos.edit')}, {:caminho=>"emails/#{@email.id}", :exibicao=>@email.id}]
      @tabsval = [{:caminho=>"emails/#{@email.id}", :exibicao=>I18n.t('application.titulos.show'),:active=>false, :icon=>'icon-info-sign' }, {:caminho=>"emails/#{@email.id}/edit", :exibicao=>I18n.t('application.titulos.edit'), :active=>true, :icon=>'icon-pencil'}, 
                  {:caminho=>'emails/history', :exibicao=>I18n.t('application.titulos.history'), :active=>false, :icon=>'icon-book'} ]
    end
  end

  # POST /Emails
  # POST /Emails.json
  def create
    account = {}
    account = {:account_id => session[:account_id]}
    params[:email].merge!(account)
      
    @email = Email.new(params[:email])

    respond_to do |format|
      if @email.save
        Rails.logger.add_metadata({:user_id =>current_user.id,
                                   :acoes=>"<em>#{I18n.t('email.mensagens.create_email_log')}  #{@email.title}</em>",
                                   :ipvalue=>request.remote_ip, :time=>Time.now}) if Rails.logger.respond_to?(:add_metadata)
        action_rep = get_action(params[:sub], @email.id)
        flash[:success] = I18n.t('email.mensagens.create_success')
        format.html { redirect_to :action=>action_rep}
        format.json { render json: @email, status: :created, location: @email }
      else
        flash.now[:error] = I18n.t('email.mensagens.create_fail')
        @breadcumb = [{:caminho=>'home', :exibicao=>I18n.t('application.titulos.home')}, {:caminho=>'emails', :exibicao=>'emails'}, 
                  {:caminho=>"emails/new/", :exibicao=>I18n.t('application.titulos.new')}]
        @tabsval = [{:caminho=>'emails', :exibicao=>I18n.t('application.titulos.show'),:active=>false, :icon=>'icon-th-list' },
                    {:caminho=>'emails/new', :exibicao=>I18n.t('application.titulos.new'), :active=>true, :icon=>'icon-plus'},
                    {:caminho=>'emails/history', :exibicao=>I18n.t('application.titulos.history'), :active=>false, :icon=>'icon-book'} ]
        format.html { render action: "new" }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /Emails/1
  # PUT /Emails/1.json
  def update
    @email = Email.find_by_id_and_account_id(params[:id], session[:account_id])
    
    respond_to do |format|
      if @email.nil?
        flash[:error] = I18n.t('email.mensagens.not_found_account')
        format.html { redirect_to :action=>'index'}
      else
        action_rep = get_action(params[:sub], @email.id)
        if @email.update_attributes(params[:email])
          Rails.logger.add_metadata({:user_id =>current_user.id,
                                     :acoes=>"<em>#{I18n.t('email.mensagens.update_email_log')}  #{@email.title}</em>",
                                     :ipvalue=>request.remote_ip, :time=>Time.now}) if Rails.logger.respond_to?(:add_metadata)
          
          flash[:success] = I18n.t('email.mensagens.update_success')
          format.html { redirect_to :action=>action_rep}
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @email.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /Emails/1
  # DELETE /Emails/1.json
  def destroy
    @email = Email.find_by_id_and_account_id(params[:id], session[:account_id])
    if @email.nil?
        respond_to do |format|
          flash[:error] = I18n.t('email.mensagens.not_found_account')
          format.html { redirect_to :action=>'index'}
        end
    else
      title = @email.title 
      @email.destroy
      flash[:success] = I18n.t('email.mensagens.delete_success')
      Rails.logger.add_metadata({:user_id =>current_user.id,
                                     :acoes=>"<em>#{I18n.t('email.mensagens.delete_email_log')}  #{title}</em>",
                                     :ipvalue=>request.remote_ip, :time=>Time.now}) if Rails.logger.respond_to?(:add_metadata)
          
      respond_to do |format|
        format.html { redirect_to emails_url }
        format.json { head :no_content }
      end
    end
  end
  
  def history
    @breadcumb = [{:caminho=>'home', :exibicao=>I18n.t('application.titulos.home')}, {:caminho=>'emails', :exibicao=>'emails'}, {:caminho=>"emails/history/", :exibicao=>I18n.t('application.titulos.history')}]
    @tabsval = [{:caminho=>'emails', :exibicao=>I18n.t('application.titulos.index'),:active=>false, :icon=>'icon-th-list' }, {:caminho=>'emails/new', :exibicao=>I18n.t('application.titulos.new'), :active=>false, :icon=>'icon-plus'}, 
         {:caminho=>'emails/history', :exibicao=>I18n.t('application.titulos.history'), :active=>true, :icon=>'icon-book'} ]
    @logs = {}
    
    db = Rails.logger.mongo_connection
    collection = db[Rails.logger.mongo_collection_name]    
    @logs[:update] = collection.find({:user_id=>current_user.id, "controller"=>"emails", "action"=>'update'})  
    @logs[:insert] = collection.find({:user_id=>current_user.id, "controller"=>"emails", "action"=>'create'})
    @logs[:destroy] = collection.find({:user_id=>current_user.id, "controller"=>"emails", "action"=>'destroy'})
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @logs }
    end
  end
  
private
  def load_copy
    respond_to do |format|
       format.js
    end 
  end
  
protected
  def load_status
    @status = Status.where("id IN (?)", [Status::ATIVO, Status::INATIVO]).collect{ |m|[m.name, m.id]}
  end
end
