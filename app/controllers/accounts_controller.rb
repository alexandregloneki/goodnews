class AccountsController < ApplicationController
  # GET /accounts
  # GET /accounts.json
  def index
    @account = Account.first(:conditions=>{:user_id=>current_user.id})
    @breadcumb = [{:caminho=>'home', :exibicao=>I18n.t('application.titulos.home')}, {:caminho=>'accounts', :exibicao=>I18n.t('application.titulos.account')}]
    @tabsval = [{:caminho=>'accounts', :exibicao=>I18n.t('application.titulos.account'),:active=>true, :icon=>'icon-user' },
                {:caminho=>"accounts/edit", :exibicao=>I18n.t('application.titulos.edit'), :active=>false, :icon=>'icon-pencil'}]
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @account}
    end
  end

  # GET /accounts/1/edit
  def edit
    @user = User.find(current_user.id)
    @breadcumb = [{:caminho=>'home', :exibicao=>I18n.t('application.titulos.home')}, {:caminho=>'accounts', :exibicao=>I18n.t('application.titulos.account')},
                  {:caminho=>'accounts/edit', :exibicao=>I18n.t('application.titulos.edit')}]
    @tabsval = [{:caminho=>'accounts', :exibicao=>I18n.t('application.titulos.account'),:active=>false, :icon=>'icon-user' },
                {:caminho=>"accounts/edit", :exibicao=>I18n.t('application.titulos.edit'), :active=>true, :icon=>'icon-pencil'}]
  end

  # PUT /accounts/1
  # PUT /accounts/1.json
  def update
    @user = User.find(current_user.id)

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:success] = I18n.t('account.mensagens.edit_success')
        format.html { redirect_to :action=>'index'}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def key_generate
    @account = Account.first(:conditions=>{:user_id=>current_user.id})
    @chave = SecureRandom.hex(10)
    @account.update_attribute(:token_access, @chave)
    
  end

end
