class Sendmail < ActiveRecord::Base
  belongs_to :email
  belongs_to :workflow
  
  def self.clear_data(workflow_id)
    Sendmail.delete_all(["workflow_id = ?", workflow_id])
  end
end
