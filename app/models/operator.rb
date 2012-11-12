class Operator < ActiveRecord::Base
  validates_presence_of :name, :simbol
end
