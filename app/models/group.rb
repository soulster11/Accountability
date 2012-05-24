class Group < ActiveRecord::Base
	has_many :memberships
	has_many :people, :through => :memberships
	has_many :attendances, :through => :people
	belongs_to :leader, :class_name => 'Person'
	acts_as_tree :order => 'position'
	belongs_to :network
end
