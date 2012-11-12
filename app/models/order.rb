class Order < ActiveRecord::Base
  belongs_to :account
  belongs_to :plan
  belongs_to :status
end
