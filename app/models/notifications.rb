class Notifications < ActionMailer::Base

  self.smtp_settings = {
    :address => "#{LOCAL['mail_server']}.#{LOCAL['domain_name']}",
    :port => 25,
    :domain => LOCAL['domain_name']
  }
  
  def new_password(address, user, pass, sent = Time.now)
    @subject       = "Your password is ..."
    @username      = user
    @password      = pass
    @recipients    = address
    @from          = "admin@#{LOCAL['domain_name']}"
    @sent_on       = sent
    #@headers       = {}
  end

	def reminder(service, group, absences, sent = Time.now)
		@subject       = "Reminder to update attendance for group \"#{group.designation}\""
    @from          = "admin@#{LOCAL['domain_name']}"
		@sent_on       = sent
		@service       = service
		@recipients    = group.leader.email_address
		@group         = group
		@absences      = absences
	end

end
