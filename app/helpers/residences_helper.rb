module ResidencesHelper

	def list_dependents(p)
		list = []
		p.dependents.each do |d|
			if d.last_name != p.last_name
				list << link_to(d.full_name, person_path(d))
			else
				list << link_to(d.first_name, person_path(d))
			end
		end
		return list.to_sentence
	end

	def print_dependents(p)
		list = []
		p.dependents.each do |d|
			if d.last_name != p.last_name
				list << d.full_name
			else
				list << d.first_name
			end
		end
		return list.to_sentence
	end

end
