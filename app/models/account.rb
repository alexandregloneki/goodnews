class Account < ActiveRecord::Base
  belongs_to :user
  belongs_to :status
  
  def self.create_new(user_id)
    @account = Account.new(:user_id=>user_id, :status_id=>3)
    @account.save
  end
  
  def self.valid_user?(token)
    account = Account.find_by_token_access(token)
    if account.nil?
      return false
    else
      return true
    end
  end
end
