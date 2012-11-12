class Emailnotification < ActiveRecord::Base
  belongs_to :email
  belongs_to :notification
end
