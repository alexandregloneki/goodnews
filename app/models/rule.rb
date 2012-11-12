class Rule < ActiveRecord::Base
  belongs_to :operator
  belongs_to :workflow
  belongs_to :type_field
  validates_presence_of :name, :field_references, :field_comparation, :value_comparation, :operator
  validates_associated :operator

end
