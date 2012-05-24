class Network < ActiveRecord::Base
	has_many :groups
	has_many :services
	has_many :schedules
end
