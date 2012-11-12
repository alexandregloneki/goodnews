class Sendsm < ActiveRecord::Base
  belongs_to :sm
  belongs_to :workflow
  
  def self.clear_data(workflow_id)
    Sendsm.delete_all(["workflow_id = ?", workflow_id])
  end
  
end
