class Email < ActiveRecord::Base
  belongs_to :status
  belongs_to :workflow
  belongs_to :account
  belongs_to :sendmail
  validates_presence_of :title
  validates_uniqueness_of :title, :unless => :validates_uniquess_title_for_account
  
  
  def validates_uniquess_title_for_account
    nome = Email.find_by_title_and_account_id(title, account_id)
    if nome.nil?
      return true
    else
      return false
    end
  end

end
