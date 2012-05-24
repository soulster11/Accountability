class User < ActiveRecord::Base

	belongs_to :person

	validates_length_of :username, :within => 3..40
	validates_presence_of :username, :password, :salt
	validates_uniqueness_of :username
	validates_confirmation_of :password 

	attr_protected :id, :salt, :admin

end

