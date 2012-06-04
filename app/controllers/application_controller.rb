class ApplicationController < ActionController::Base
  protect_from_forgery

	layout :detect_browser

	# Never getting called. Fix the (supposed) problem, or take out?
	def sort_order(default)
		"#{(params[:c] || default.to_s).gsub(/[\s;'\"]/,'')} #{params[:d] == 'down' ? 'DESC' : 'ASC'}"
	end
		
	require 'digest/sha1'

	def encrypt(pass, salt)
		Digest::SHA1.hexdigest(pass + salt)
	end

	def random_string(len)
		# Generate a random password consisting of strings and digits
		chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
		junk = ""
		1.upto(len) { |i| junk << chars[rand(chars.size-1)] }
		return junk
	end
	
	def redirect_to_stored
		if return_to = session[:return_to]
			session[:return_to] = nil
			redirect_to(return_to)
		else
			redirect_to :controller => 'attendances', :action => 'take'
		end
	end

protected

	def get_user
		return if session[:username].blank?
		@user = User.find_by_username(session[:username])
	end

	def logged_in?
		get_user
		! @user.blank?
	end

	def admin?
		get_user
		return @user.administrator if @user
		false
	end

	def login_required
		return true if logged_in?
		session[:return_to] = request.request_uri
		redirect_to :controller => 'users', :action => 'login'
	end

	def admin_required
		return true if admin?
		session[:return_to] = request.request_uri
		redirect_to :controller => 'users', :action => 'login'
	end

	MOBILE_BROWSERS = ["android", "ipod", "opera mini", "blackberry", "palm", "hiptop", "avantgo", "plucker", "xiino", "blazer", "elaine", "windows ce; ppc;", "windows ce; smartphone;", "windows ce; iemobile", "up.browser", "up.link", "mmp", "symbian", "smartphone", "midp", "wap", "vodafone", "o2", "pocket", "kindle", "mobile", "pda", "psp", "treo"]

	def detect_browser
		agent = request.headers["HTTP_USER_AGENT"].downcase
		MOBILE_BROWSERS.each do |m|
			return "mobile" if agent.match(m)
		end
		return "application"
	end

	def redirect_palm
		agent = request.headers['HTTP_USER_AGENT'].downcase
		return 'old' if agent.match('blazer')
		'take'
	end

	# http://railscasts.com/episodes/199-mobile-devices
	#helper :all
	#protect_from_forgery
	#def mobile_device?
	#	user_agent = request.user_agent
	#	user_agent =~ /Mobile|webOS/
	#end
	#helper_method :mobile_device?

end
