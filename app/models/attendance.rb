class Attendance < ActiveRecord::Base
  belongs_to :person
  belongs_to :service
	has_one :network, :through => :service
  belongs_to :status
  validates_uniqueness_of :person_id, :scope => :service_id
end
