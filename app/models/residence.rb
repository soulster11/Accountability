class Residence < ActiveRecord::Base

	has_many :people

	# According to http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html,
	# this should work, but it doesn't...
	#has_many :heads, :class_name => "People", :conditions => "type_id = 1"

	validates_presence_of :address1, :city, :state, :zip
	validates_uniqueness_of :address1, :scope => [:address2, :city, :state, :zip]

	def full_address
		full_address = address1
		full_address += ", #{address2}" unless address2.blank?
		full_address += ", #{city}"
		full_address += ", #{state}"
		full_address += ", #{zip}"
	end

	def head
		self.people.find(:first, :conditions => "type_id = 1")
	end

end
