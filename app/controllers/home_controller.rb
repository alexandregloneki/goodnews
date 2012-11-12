class HomeController < ApplicationController
  def index
    @emails = Email.count(:all, :conditions=>{:account_id=>session[:account_id]})
    @sms = Sm.count(:all, :conditions=>{:account_id=>session[:account_id]})
    @workflows = Workflow.count(:all, :conditions=>{:account_id=>session[:account_id]})
    @comunication_month_3 = Emailnotification.count(:all, :conditions=>["notifications.account_id = ? AND  MONTH(notifications.created_at) = ?", session[:account_id], Time.zone.now.month-3], 
    :joins=>'INNER JOIN notifications  ON notifications.id = emailnotifications.notification_id')
    @comunication_month_2 = Emailnotification.count(:all, :conditions=>["notifications.account_id = ? AND  MONTH(notifications.created_at) = ?", session[:account_id], Time.zone.now.month-2], 
    :joins=>'INNER JOIN notifications ON notifications.id = emailnotifications.notification_id')
    
    @comunication_month_1 = Emailnotification.count(:all, :conditions=>["notifications.account_id = ? AND  MONTH(notifications.created_at) = ? ", session[:account_id], Time.zone.now.month-1], 
    :joins=>'INNER JOIN notifications ON notifications.id = emailnotifications.notification_id')
    
    @comunication_month = Emailnotification.count(:all, :conditions=>["notifications.account_id = ? AND  MONTH(notifications.created_at) = ?", session[:account_id], Time.zone.now.month], 
    :joins=>'INNER JOIN notifications ON notifications.id = emailnotifications.notification_id')
    
    
    @comunication_month_s3 = Smsnotification.count(:all, :conditions=>["notifications.account_id = ? AND  MONTH(notifications.created_at) = ?", session[:account_id], Time.zone.now.month-3], 
    :joins=>'INNER JOIN notifications ON notifications.id = smsnotifications.notification_id')
    @comunication_month_s2 = Smsnotification.count(:all, :conditions=>["notifications.account_id = ? AND  MONTH(notifications.created_at) = ?", session[:account_id], Time.zone.now.month-2], 
    :joins=>'INNER JOIN notifications ON notifications.id = smsnotifications.notification_id')
    
    @comunication_month_s1 = Smsnotification.count(:all, :conditions=>["notifications.account_id = ? AND  MONTH(notifications.created_at) = ?", session[:account_id], Time.zone.now.month-1], 
    :joins=>'INNER JOIN notifications ON notifications.id = smsnotifications.notification_id')
    
    @comunication_month_s = Smsnotification.count(:all, :conditions=>["notifications.account_id = ? AND  MONTH(notifications.created_at) = ?", session[:account_id], Time.zone.now.month], 
    :joins=>'INNER JOIN notifications ON notifications.id = smsnotifications.notification_id')
    
    
    
  end

end
