class EmailEmailer < ActionEmailer::Base
  default from: "aaparecido@tray.com.br"
    
  def send_Email(Email)
    to Email.to
    cc Email.cc unless Email.cc.ni?
    subject Email.title
    message Email.message
  end
end
