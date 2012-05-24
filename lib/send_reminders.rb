#!script/runner

networks = Network.all.select { |n| !n.groups.empty? }
networks.each do |network|
	service = Service.last(:conditions => "DATE(date_and_time) <= DATE(NOW()) and " +
		"network_id = #{network.id}", :order => 'date_and_time')
	unless service.nil?
		absences = Attendance.all(:conditions => "service_id = #{service.id} and " +
			"status_id > 5 and (contacted = false or contacted is null)")
		groups = Group.all.select { |g| g.children.empty? && g.network_id == network.id }
		groups.each do |group|
			group_absences = absences.select { |a| a.person.groups.include?(group) }
			unless group_absences.empty?
				Notifications.deliver_reminder(service, group, group_absences)
			else
				current = false
				group.people.each do |p|
					if !p.attendances.empty? && p.attendances.last.service == service
						current = true
						break
					end
				end
				unless current
					# Yes, this is just like the line above, but I don't want to make a
					# function for just one line...
					Notifications.deliver_reminder(service, group, group_absences)
				end
			end
		end
	end
end
