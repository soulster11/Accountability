module AttendancesHelper

	def colorize(status)
		"warning" if status > 5
	end

end
