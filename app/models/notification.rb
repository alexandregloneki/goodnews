class Notification < ActiveRecord::Base
  belongs_to :workflow
  belongs_to :account
end
