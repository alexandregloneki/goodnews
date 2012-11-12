class SmsController < ApplicationController
  # GET /sms
  # GET /sms.json
  before_filter :load_status
  def index
    @sms_grid = initialize_grid(Sm, :conditions=>["account_id = ?", session[:account_id]],
                                        :name=>'sms',
                                        :enable_export_to_csv => true,
                                        :csv_field_separator => ';',
                                        :csv_file_name=>'sms'
                                        )
    
    @breadcumb = [{:caminho=>'home', :exibicao=>'Home'}, {:caminho=>'sms', :exibicao=>'sms'}]
    @tabsval = [{:caminho=>'sms', :exibicao=>'Listar',:active=>true, :icon=>'icon-th-list' }, {:caminho=>'sms/new', :exibicao=>'Novo', :active=>false, :icon=>'icon-plus'}, 
               {:caminho=>'sms/history', :exibicao=>'Historico', :active=>false, :icon=>'icon-book'} ]
   export_grid_if_requested('sms'=>'sms_grid')
  end

  # GET /sms/1
  # GET /sms/1.json
  def show
    @sm = Sm.find_by_id_and_account_id(params[:id], session[:account_id])
    if @sm.nil?
        flash[:error] = 'Sms nao encontrado para esta conta.'
    else
      @breadcumb = [{:caminho=>'home', :exibicao=>'Home'}, {:caminho=>'sms', :exibicao=>'sms'}, 
                    {:caminho=>"sms/#{@sm.id}", :exibicao=>@sm.id}]
      @tabsval = [{:caminho=>'sms', :exibicao=>'Listar',:active=>false, :icon=>'icon-th-list' },
                  {:caminho=>"sms/#{@sm.id}", :exibicao=>'Mostrar', :active=>true, :icon=>'icon-info-sign'},
                  {:caminho=>"sms/#{@sm.id}/edit", :exibicao=>'Editar', :active=>false, :icon=>'icon-pencil'},
                  {:caminho=>'sms/new', :exibicao=>'Novo', :active=>false, :icon=>'icon-plus'},
                  {:caminho=>'sms/history', :exibicao=>'Historico', :active=>false, :icon=>'icon-book'} ]
    end  
    respond_to do |format|
      format.html { redirect_to :action=>'index'} if @sm.nil?
      format.html # show.html.erb
      format.json { render json: @sm }
    end
  end

  # GET /sms/new
  # GET /sms/new.json
  def new
    @sm = Sm.new
    @breadcumb = [{:caminho=>'home', :exibicao=>'Home'}, {:caminho=>'sms', :exibicao=>'sms'}, 
                  {:caminho=>"sms/new/", :exibicao=>'Novo'}]
    @tabsval = [{:caminho=>'sms', :exibicao=>'Listar',:active=>false, :icon=>'icon-th-list' },
                {:caminho=>'sms/new', :exibicao=>'Novo', :active=>true, :icon=>'icon-plus'},
                {:caminho=>'sms/history', :exibicao=>'Historico', :active=>false, :icon=>'icon-book'} ]
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sm }
    end
  end

  # GET /sms/1/edit
  def edit
    @sm = Sm.find_by_id_and_account_id(params[:id], session[:account_id])
    if @sm.nil?
      flash[:error] = 'Sms nao encontrado para esta conta.'
      respond_to do |format|
        format.html { redirect_to :action=>'index'}
      end
    else
      @breadcumb = [{:caminho=>'home', :exibicao=>'Home'}, {:caminho=>'sms', :exibicao=>'sms'}, 
                    {:caminho=>"sms/#{@sm.id}/edit/", :exibicao=>'Editar'}, {:caminho=>"sms/#{@sm.id}", :exibicao=>@sm.id}]
      @tabsval = [{:caminho=>"sms/#{@sm.id}", :exibicao=>'Mostrar',:active=>false, :icon=>'icon-info-sign' }, {:caminho=>"sms/#{@sm.id}/edit", :exibicao=>'Edit', :active=>true, :icon=>'icon-pencil'}, 
                  {:caminho=>'sms/history', :exibicao=>'Historico', :active=>false, :icon=>'icon-book'} ]
    end
  end

  # POST /sms
  # POST /sms.json
  def create
    account = {}
    account = {:account_id => session[:account_id]}
    params[:sm].merge!(account)
    @sm = Sm.new(params[:sm])

    respond_to do |format|
      if @sm.save
        Rails.logger.add_metadata({:user_id =>current_user.id,
                                   :acoes=>"<em>criado o sms de id #{@sm.id}</em>",
                                   :ipvalue=>request.remote_ip, :time=>Time.now}) if Rails.logger.respond_to?(:add_metadata)
        action_rep = get_action(params[:sub], @sm.id)
        flash[:success] = 'Sms criado com sucesso!'
        format.html { redirect_to :action=>action_rep}
        format.json { render json: @sm, status: :created, location: @sm }
      else
        flash.now[:error] = 'Email was not created.'
        @breadcumb = [{:caminho=>'home', :exibicao=>'Home'}, {:caminho=>'sms', :exibicao=>'sms'}, 
                  {:caminho=>"sms/new/", :exibicao=>'Novo'}]
        @tabsval = [{:caminho=>'sms', :exibicao=>'Listar',:active=>false, :icon=>'icon-th-list' },
                    {:caminho=>'sms/new', :exibicao=>'Novo', :active=>true, :icon=>'icon-plus'},
                    {:caminho=>'sms/history', :exibicao=>'Historico', :active=>false, :icon=>'icon-book'} ]
        
        format.html { render action: "new", error: 'Sms was not created'}
        format.json { render json: @sm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sms/1
  # PUT /sms/1.json
  def update
    @sm = Sm.find_by_id_and_account_id(params[:id], session[:account_id])

    respond_to do |format|
      if @sm.nil?
        flash[:error] = 'Sms nao encontrado para esta conta.'
        format.html { redirect_to :action=>'index'}
      else
        if @sm.update_attributes(params[:sm])
          Rails.logger.add_metadata({:user_id =>current_user.id,
                                     :acoes=>"<em>alterado o sms de id #{@sm.id}</em>",
                                     :ipvalue=>request.remote_ip, :time=>Time.now}) if Rails.logger.respond_to?(:add_metadata)
          
          action_rep = get_action(params[:sub], @sm.id)
          flash[:success] = 'Sms alterado com sucesso!'
          format.html { redirect_to :action=>action_rep}
          format.json { head :no_content }
        else
          format.html { render action: "edit", error: 'Sms was not updated' }
          format.json { render json: @sm.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /sms/1
  # DELETE /sms/1.json
  def destroy
    @sm = Sm.find_by_id_and_account_id(params[:id], session[:account_id])
    if @sm.nil?
        respond_to do |format|
          flash[:error] = 'Sms nao encontrado para esta conta.'
          format.html { redirect_to :action=>'index'}
        end
    else
      @sm.destroy
      Rails.logger.add_metadata({:user_id =>current_user.id,
                                     :acoes=>"<em>removido o sms de id #{params[:id]}</em>",
                                     :ipvalue=>request.remote_ip, :time=>Time.now}) if Rails.logger.respond_to?(:add_metadata)
          
      respond_to do |format|
        format.html { redirect_to sms_url, :flash=>{:success=>'Sms excluido com sucesso!.'} }
        format.json { head :no_content }
      end
    end
  end
  
  def history
    @breadcumb = [{:caminho=>'home', :exibicao=>'Home'}, {:caminho=>'sms', :exibicao=>'sms'}, {:caminho=>"sms/history/", :exibicao=>'historico'}]
    @tabsval = [{:caminho=>'sms', :exibicao=>'Listar',:active=>false, :icon=>'icon-th-list' }, {:caminho=>'sms/new', :exibicao=>'Novo', :active=>false, :icon=>'icon-plus'}, 
         {:caminho=>'sms/history', :exibicao=>'Historico', :active=>true, :icon=>'icon-book'} ]
    @logs = {}
    
    db = Rails.logger.mongo_connection
    collection = db[Rails.logger.mongo_collection_name]    
    @logs[:update] = collection.find({:user_id=>current_user.id, "controller"=>"sms", "action"=>'update'})  
    @logs[:insert] = collection.find({:user_id=>current_user.id, "controller"=>"sms", "action"=>'create'})
    @logs[:destroy] = collection.find({:user_id=>current_user.id, "controller"=>"sms", "action"=>'destroy'})
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @logs }
    end
  end
    
protected
  def load_status
    @status = Status.where('id IN (?)', [Status::ATIVO, Status::INATIVO]).collect{ |m|[m.name, m.id]}
  end

end
