class Schedule < ActiveRecord::Base
	belongs_to :network

	DAYS = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']

	def printable_time
		standard_time.strftime("%r")
	end

	def generate_services
		logger = Logger.new(STDERR)
		today = Date.today
		offset = DAYS.rindex(default_day) - today.cwday
		offset = 7 + offset if offset < 0
		service_day = today + offset
		logger.info(service_day)
		(0..52).each do
			d = "#{service_day.to_s(:db)} #{self.standard_time.strftime("%R")}:00"
			logger.info(d)
			Service.find_or_create_by_dateandtime_and_network_id(d, self.network_id)
			service_day += 7
		end
	end

end
