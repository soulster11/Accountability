class Service < ActiveRecord::Base
	has_many :attendances
	belongs_to :network

	validates_uniqueness_of :dateandtime, :scope => :network_id
	
	def printable_date
		self.dateandtime.to_datetime.strftime("%a, %b %d, %Y @ %H:%M %P")
	end

end
