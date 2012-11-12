class Workflow < ActiveRecord::Base
  has_one :account
  belongs_to :email
  has_many :rules, :dependent=>:destroy
  accepts_nested_attributes_for :rules, :allow_destroy => true
  belongs_to :sms
  belongs_to :status
  validates_presence_of :name
  validates_uniqueness_of :name, :unless => :validates_uniquess_name_for_account
  
  
  def validates_uniquess_name_for_account
    nome = Workflow.find_by_name_and_account_id(name, account_id)
    if nome.nil?
      return true
    else
      return false
    end
  end
  
end
