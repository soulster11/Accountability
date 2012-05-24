module GroupsHelper

	def display_tree_recursive(tree, parent_id)
		ret = "\n<ul>"
		tree.each do |node|
			if node.parent_id == parent_id
				ret += "<h3>#{node.network.designation}</h3>" if parent_id.nil?
				ret += "\n\t<li>"
				ret += link_to node.designation, edit_group_path(node)
				ret += " (#{node.people.count})"
				ret += " (" + node.leader.full_name + ")" unless node.leader.nil?
				ret += display_tree_recursive(tree, node.id) { |n| yield n } unless node.children.empty?
				ret += "\t</li>\n"
			end
		end
		ret += "</ul>\n"
	end

	def list(group)
		@ret += link_to group.designation, group
		@ret += " ("
		@ret += link_to 'Edit', edit_group_path(group)
		@ret += ")"
		@ret += "<br/>"
		unless group.leader.nil?
			@ret += group.leader.full_name
		else
			@ret += "Unmanaged"
		end
		if group.children.size > 0
			@ret += "<li>"
			group.children.each do |child|
				@ret += list(child)
			end
			@ret += "</li>"
		end
	end
  
  
	def list_all_groups(group)
		if group.children.size > 0
			ret = "<div style='text-align: left'><ul>\n"
			group.children.each { |child|
				ret += "<li>"
				ret += link_to child.designation, child
				#if session[:authenticated]
					ret += " ("
					ret += link_to 'Edit', edit_group_path(child)
					ret += ")"
				#end
				ret += "<br/>"
        unless child.leader.nil?
				  ret += child.leader.full_name
				else
          ret += "Unmanaged"
        end
				ret += "\n"
				if child.children.size > 0
					ret += list_all_groups(child)
				end
				ret += "</li>\n"
			}
		ret += "</ul>\n"
		end
	end
	
end
