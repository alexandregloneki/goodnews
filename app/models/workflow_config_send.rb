class WorkflowConfigSend < ActiveRecord::Base
  belongs_to :workflow
  belongs_to :email
  belongs_to :sm
  belongs_to :account
end
