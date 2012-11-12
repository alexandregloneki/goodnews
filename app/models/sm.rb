require 'net/https'
require 'uri'

class Sm < ActiveRecord::Base
  
  USUARIO = 'gloneki.dev@gmail.com'
  SENHA = '925569'
  URL_SMS = "http://www.vexxmobile.com.br/http.php?metodo=enviarsms&usuario=#{USUARIO}&senha=#{SENHA}"
  belongs_to :status
  belongs_to :workflow
  belongs_to :account
  validates_presence_of :name
  validates_uniqueness_of :name, :unless => :validates_uniquess_name_for_account
  
  
  def validates_uniquess_name_for_account
    nome = Sm.find_by_name_and_account_id(name, account_id)
    if nome.nil?
      return true
    else
      return false
    end
  end
  
  def self.send_sms(id)
    sms = Sm.find_by_id(id)
    unless sms.nil?
      phone = sms.number_dispatch.gsub("(","").gsub(" ","")
      phone_final = "55"+phone.gsub(")", "").gsub("-", "")
      result = Net::HTTP.get(URI.parse("#{URL_SMS}"+"&telefone=#{phone_final}&mensagem=#{sms.message}"))
    end
  end
end
