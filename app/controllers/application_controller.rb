class ApplicationController < ActionController::Base
  include MongodbLogger::Base
  skip_before_filter :api
  before_filter :authenticate_user!, :log_user
  layout :layout_by_resource
  include ApplicationHelper
  protect_from_forgery :except => [:confirm]


protected
  def layout_by_resource
    if devise_controller?
      "login"
    else
      "application"
    end
  end
  
  def log_user
    unless current_user.nil?
      Rails.logger.add_metadata({:user_id=>current_user.id, :email=>current_user.email}) if Rails.logger.respond_to?(:add_metadata)
      @account = Account.find_by_user_id(current_user.id)
      Account.create_new(current_user.id) if @account.nil?
      account_object = Account.first(:conditions=>{:user_id=>current_user.id})
      session[:account_id] = account_object.id
    end
  end
end
