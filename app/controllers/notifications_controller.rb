class NotificationsController < ApplicationController
  # GET /notifications
  # GET /notifications.json
  def index
    
    @notifications_grid = initialize_grid(Notification, :conditions=>["account_id = ?", session[:account_id]],
                                        :name=>'notifications',
                                        :enable_export_to_csv => true,
                                        :csv_field_separator => ';',
                                        :csv_file_name=>'notifications'
                                        
                                        )
    @breadcumb = [{:caminho=>'home', :exibicao=>I18n.t('application.titulos.home')}, {:caminho=>'notifications', :exibicao=>'notificacoes'}]
    @tabsval = [{:caminho=>'notifications', :exibicao=>I18n.t('application.titulos.index'),:active=>true, :icon=>'icon-th-list' }]
       
    export_grid_if_requested('notifications'=>'notifications_grid')
    
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
    
    @notification = Notification.find_by_id_and_account_id(params[:id], session[:account_id])
    
    if @notification.nil?
        flash[:error] = I18n.t('email.mensagens.not_found_account')
    else
      @emails = Sendmail.where('workflow_id = ?', @notification.workflow_id)
      @sms = Sendsm.where('workflow_id = ?', @notification.workflow_id)
      @breadcumb = [{:caminho=>'home', :exibicao=>I18n.t('application.titulos.home')}, {:caminho=>'notifications', :exibicao=>'notificacoes'}, 
                    {:caminho=>"notifications/#{@notification.id}", :exibicao=>@notification.id}]
      @tabsval = [{:caminho=>'notifications', :exibicao=>I18n.t('application.titulos.index'),:active=>false, :icon=>'icon-th-list' },
                  {:caminho=>"notifications/#{@notification.id}", :exibicao=>I18n.t('application.titulos.show'), :active=>true, :icon=>'icon-info-sign'}]
    end
    
    respond_to do |format|
      format.html { redirect_to :action=>'index'} if @notification.nil?
      format.html # show.html.erb
      format.json { render json: @notification }
    end
  end
end
