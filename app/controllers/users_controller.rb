class UsersController < ApplicationController

	#before_filter :login_required, :only => ['change', 'logout']
	before_filter :admin_required, :only => ['index', 'new', 'create', 'edit', 'update']
	before_filter :login_required, :except => [:login, :reset]

	def index
		@users = User.all
	end
	
	def new
		@user = User.new
		respond_to do |format|
			format.html # new.html.erb
			format.xml	{ render :xml => @user }
		end
	end

	def create
		if request.post?
			unless params[:password].blank? || params[:confirm].blank? ||
				params[:password] != params[:confirm]
				@user = User.new(params[:user])
				@user.salt = random_string(6)
				@user.password = encrypt(params[:password], @user.salt)
				flash[:notice] = 'User was successfully created.'
			else
				flash[:notice] = "The passwords do not match."
			end
		end	 
		respond_to do |format|
			if @user.save
				format.html { redirect_to(@user) }
				format.xml	{ render :xml => @user, :status => :created, :location => @user }
			else
				format.html { render :action => "new" }
				format.xml	{ render :xml => @user.errors, :status => :unprocessable_entity }
			end
		end
	end

	def edit
		@user = User.find(params[:id])
	end
	
	def update
		@user = User.find(params[:id])
		if params[:new_password] == params[:confirm]
			@user.salt = random_string(6) if !@user.salt?
			@user.password = encrypt(params[:new_password], @user.salt)
		end	
		respond_to do |format|
			if @user.update_attributes(params[:user]) &&
			 	params[:new_password] == params[:confirm]
				flash[:notice] = 'User was successfully updated.'
				format.html { redirect_to(@user) }
				format.xml	{ head :ok }
			else
				flash[:notice] = 'Passwords (probably) didn\'t match.'
				format.html { render :action => "edit" }
				format.xml	{ render :xml => @user.errors, :status => :unprocessable_entity }
			end
		end
	end
	
	def show
		@user = User.find(params[:id])
	end
	
	
	def login
		if request.post?
			u = User.find_by_username(params[:user][:username])
			if u
				if encrypt(params[:user][:password], u.salt) == u.password
					session[:username] = u.username
					session[:password] = u.password
					if u.administrator
						session[:admin] = true
					end
					flash[:notice] = "Logged in as #{u.username}!"
					redirect_to_stored
				else
					flash[:notice] = "Wrong password."
				end
			else
				flash[:notice] = "No User found with that username."
			end
		end
	end


	def logout
		reset_session
		redirect_to :controller => 'attendances', :action => 'take'
	end
	
	
	def reset
		if request.post?
			u = User.find(:first, :include => :person,
				:conditions => "people.email_address = '#{params[:user][:email_address]}'")
			if u
				new_password = random_string(6)
				u.salt = random_string(6) if !u.salt?
				u.password = encrypt(new_password, u.salt)
				u.save
				if Notifications.deliver_new_password(u.person.email_address,
					u.username, new_password)
					flash[:notice] = "A new password has been sent by email. Please change it to something that you'll be able to remember."
					redirect_to :action => 'change'
				else
					flash[:notice] = "Could not send email to that address!"
					redirect_to_stored
				end
			else
				flash[:notice] = "A user with that email address was not found!"
				redirect_to_stored
			end
		end
	end


	def change
		if request.post?
			unless params[:user][:password].blank? or params[:user][:new_password].blank? or
				params[:user][:password_confirmation].blank?
				u = User.find_by_username(session[:username])
				if u && encrypt(params[:user][:password], u.salt) == u.password
					if params[:user][:new_password] == params[:user][:password_confirmation]
						u.salt = random_string(6) if !u.salt?
						u.password = encrypt(params[:user][:new_password], u.salt)
						u.save
						u = nil
						flash[:notice] = "Your password has been reset. Please log in with the new one!"
						redirect_to :action => 'login'
					else
						flash[:notice] = "Your new passwords do not match. Please try again."
					end
				else
					# Normally, a check to make sure the user was found would go here, but the check
					# would be whether the user is logged in, and that's forced by the pre-filter.
					flash[:notice] = "Your old password does not match your username. Please try again."
				end
			else
				flash[:notice] = "Please fill in all the fields and try again."
			end
		end	 
	end
	
end

