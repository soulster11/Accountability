class Person < ActiveRecord::Base
	has_many :attendances, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
	has_many :groups, :through => :memberships
	has_one :user
	belongs_to :type
	belongs_to :residence
	acts_as_tree :order => 'position'
	has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "100x100>" }
	
	def full_name
		full_name = first_name + " " + last_name
	end
	
	def proper_name
		proper_name = last_name + ", " + first_name
	end

	def spouse
		children.find(:first, :conditions => "type_id = 2")
	end

	def dependents
		children.find(:all, :conditions => "type_id = 3")
	end

	def primary_group
		groups.select { |g| g.network == Network.find(1) }[0] || groups[0]
	end

	validates_uniqueness_of :first_name, :scope => :last_name
	
end
