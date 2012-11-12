class Notify < ActionMailer::Base
  default from: "aaparecido@tray.com.br"
    
  def send_email(email_send)
    @email_send = email_send
    cc_var = @email_send.cc.nil? ? '' : @email_send.cc
    cco_var = @email_send.cco.nil? ? '' : @email_send.cco
    mail(:to=>@email_send.to, :subject=>@email_send.title, :cc=>cc_var, :bcc=>cco_var)
  end
end
