class Status < ActiveRecord::Base
	has_many :attendances
end
