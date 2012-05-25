class AttendancesController < ApplicationController

	def index
		@attendances = Attendance.find(:all, :limit => 100)

		respond_to do |format|
			format.html # index.html.erb
			format.json	{ render :json => @attendances }
		end
	end

	def show
		@attendance = Attendance.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json	{ render :json => @attendance }
		end
	end

	def new
		@attendance = Attendance.new

		respond_to do |format|
			format.html # new.html.erb
			format.json	{ render :json => @attendance }
		end
	end

	def edit
		@attendance = Attendance.find(params[:id])
	end

	def create
		@attendance = Attendance.new(params[:attendance])
		
		respond_to do |format|
      if @attendance.save
        format.html { redirect_to @attendance, :notice => 'Project was successfully created.' }
        format.json { render :json => @attendance, :status => :created, :location => @attendance }
      else
        format.html { render :action => "new" }
        format.json { render :json => @attendance.errors, :status => :unprocessable_entity }
      end
    end
	end

	def update
		@attendance = Attendance.find(params[:id])

		respond_to do |format|
      if @attendance.update_attributes(params[:attendance])
        format.html { redirect_to @attendance, :notice => 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @attendance.errors, :status => :unprocessable_entity }
      end
    end
	end

	def destroy
		@attendance = Attendance.find(params[:id])
		@attendance.destroy

		respond_to do |format|
			format.html { redirect_to attendances_url }
			format.json	{ head :no_content }
		end
	end
	
	def take
		if session[:group_id]
			@group = Group.find(session[:group_id])
			@network = @group.network
		elsif session[:network_id]
			@network = Network.find(session[:network_id])
			@group = nil
		else
			@network = Network.find(1) # Default to the whole church
			@group = nil
		end
		@services = Service.find_all_by_network_id(@network.id,
			:conditions => "DATE(dateandtime) <= '#{Date.today.strftime('%y-%m-%d')}'",
			:limit => 10, :order => "dateandtime DESC")
		if session[:service_id]
			@service = Service.find(session[:service_id])
		end
		unless @service && @service.network == @network
			@service = @services.first
		end
		unless @group.nil?
			@attendances = Array.new()
			@group.people.each do |member|
				@attendances << Attendance.find_or_create_by_person_id_and_service_id(member.id, @service.id)
			end
		end
	end

	def change_group_take
		@group = Group.find(params[:group_id])
		session[:group_id] = @group.id
		@network = @group.network
		@services = Service.find_all_by_network_id(@network.id,
			:conditions => "DATE(dateandtime) <= '#{Date.today.strftime('%y-%m-%d')}'",
			:limit => 10, :order => "dateandtime DESC")
		if session[:service_id]
			@service = Service.find(session[:service_id])
		end
		unless @service && @service.network == @network
			@service = @services.first
		end
		@attendances = Array.new()
		@group.people.each do |member|
			@attendances << Attendance.find_or_create_by_person_id_and_service_id(member.id,
				@service.id)
		end
	end

	def change_date_take
		@service = Service.find(params[:service_id])
		session[:service_id] = @service.id
		@group = Group.find(params[:group_id], :include => :people)
		@attendances = Array.new()
		@group.people.each do |member|
			@attendances << Attendance.find_or_create_by_person_id_and_service_id(member.id,
				@service.id)
		end
	end

	def commit_take
		Attendance.update(params[:attendance].keys, params[:attendance].values)
		flash[:notice] = 'Attendance was taken!'
		redirect_to :action => "take"
	end

	def report
		if session[:network_id]
			@network = Network.find(session[:network_id])
		else
			@network = Network.find(1) # Whole church.
		end
		@services = Service.find_all_by_network_id(@network.id,
			:conditions => "DATE(dateandtime) <= '#{Date.today.strftime('%y-%m-%d')}'",
			:order => "dateandtime DESC")
		if session[:service_id]
			@service = Service.find(session[:service_id])
		end
		unless @service && @service.network == @network
			@service = @services.first
		end
		@attendances = Attendance.find_all_by_service_id(@service.id, :conditions =>
			"status_id != 1", :include => :status)
		params[:c] = "status.id"
		eval "@attendances.sort! { |b, a| a.#{params[:c]} <=> b.#{params[:c]} }"
	end

  def change_group_report
    @network = Network.find(params[:network_id])
		session[:network_id] = @network.id
    @services = Service.find_all_by_network_id(@network.id,
			:conditions => "DATE(dateandtime) <= '#{Date.today.strftime('%y-%m-%d')}'",
			:order => "dateandtime DESC")
		if session[:service_id]
			@service = Service.find(session[:service_id])
		end
		unless @service && @service.network == @network
			@service = @services.first
		end
		if @service
			@attendances = Attendance.find_all_by_service_id(@service.id, :conditions =>
				"status_id != 1", :include => :status, :order => "statuses.id")
			session[:service_id] = @service.id
		else
			@attendances = []
		end
  end

	def change_date_report
		@service = Service.find(params[:service_id])
		session[:service_id] = @service.id
		@attendances = Attendance.find_all_by_service_id(@service.id, :conditions =>
			"status_id != 1", :include => :status, :order => "statuses.id")
	end

	def change_sort_report
		@service = Service.find(session[:service_id])
		@attendances = Attendance.find_all_by_service_id(@service.id, :conditions =>
			"status_id != 1", :include => :status)
		if params[:d] == "down"
			eval "@attendances.sort! { |a, b| a.#{params[:c]} <=> b.#{params[:c]} }"
		else
			eval "@attendances.sort! { |b, a| a.#{params[:c]} <=> b.#{params[:c]} }"
		end
	end

	# The following is a direct copy of "take", replacing with "followup". There's
	# got to be a more DRY way of doing this...
	def followup
		if session[:group_id]
			@group = Group.find(session[:group_id])
			@network = @group.network
		elsif session[:network_id]
			@network = Network.find(session[:network_id])
			@group = nil
		else
			@network = Network.find(1) # Default to the whole church
			@group = nil
		end
		@services = Service.find_all_by_network_id(@network.id,
			:conditions => "DATE(dateandtime) <= '#{Date.today.strftime('%y-%m-%d')}'",
			:limit => 10, :order => "dateandtime DESC")
    if session[:service_id]
			@service = Service.find(session[:service_id])
		else
			@service = @services.first
			session[:service_id] = @service.id
		end
		unless @group.nil?
			@attendances = Array.new()
			@group.people.each do |member|
				@attendances << Attendance.find_or_create_by_person_id_and_service_id(member.id,
					@service.id)
			end
		end
	end

	def get_services
		@group = Group.find(params[:group_id])
		@services = Service.find_all_by_network_id(@group.network.id,
			:conditions => "DATE(dateandtime) <= '#{Date.today.strftime('%y-%m-%d')}'",
			:limit => 10, :order => "dateandtime DESC")
		#render :partial => "services", :locals => { :services => @services }
	end

	def change_group_followup
		@group = Group.find(params[:group_id])
		session[:group_id] = @group.id
		@network = @group.network
		@services = Service.find_all_by_network_id(@network.id,
			:conditions => "DATE(dateandtime) <= '#{Date.today.strftime('%y-%m-%d')}'",
			:limit => 10, :order => "dateandtime DESC")
		if session[:service_id]
			@service = Service.find(session[:service_id])
		end
		unless @service && @service.network == @network
			@service = @services.first
		end
		@attendances = Array.new()
		@group.people.each do |member|
			@attendances << Attendance.find_or_create_by_person_id_and_service_id(member.id,
				@service.id)
		end
	end

	def change_date_followup
		@service = Service.find(params[:service_id])
		session[:service_id] = @service.id
		@group = Group.find(params[:group_id], :include => :people)
		@attendances = Array.new()
		@group.people.each do |member|
			@attendances << Attendance.find_or_create_by_person_id_and_service_id(member.id,
				@service.id)
		end
	end

	def commit_followup
		Attendance.update(params[:attendance].keys, params[:attendance].values)
		flash[:notice] = 'Attendance was followed-up!'
		redirect_to :action => "followup"
	end

	def lookup
		@person = Person.find(params[:person][:id])
		start_date = Date.new(params[:service]["start(1i)".to_s].to_i, 
			params[:service]["start(2i)".to_s].to_i, 
			params[:service]["start(3i)".to_s].to_i) 
		end_date = Date.new(params[:service]["end(1i)".to_s].to_i, 
			params[:service]["end(2i)".to_s].to_i, 
			params[:service]["end(3i)".to_s].to_i) 
		@services = Service.all(:conditions => "dateandtime >= '#{start_date}' " +
			"and dateandtime <= '#{end_date}'")
		@attendances = Attendance.find_all_by_person_id(@person.id, :conditions => 
			"services.dateandtime >= '#{start_date}' and services.dateandtime <= '#{end_date}'",
			:include => :service, :order => 'services.dateandtime')
		# FIXME? "Present" relies on Status with id = 1
		@absences = Attendance.find_all_by_person_id(@person.id, :conditions => 
			"services.dateandtime >= '#{start_date}' and services.dateandtime <= '#{end_date}'" +
			'and status_id > 1', :include => :service, :order => 'services.dateandtime')
	end

	def choose
		@service = Service.find(params[:service][:id])
		@group = Group.find(params[:group][:id], :include => :people)
		@attendances = []
		@group.people.each do |member|
			@attendances << Attendance.find_or_create_by_person_id_and_service_id(member.id,
				@service.id)
		end
	end

	def register
		Attendance.update(params[:attendance].keys, params[:attendance].values)
		flash[:notice] = 'Attendance was taken!'
		redirect_to :action => "old"
	end

	def mobile
		@network = Network.find(1) # Default to the whole church
		@services = Service.find_all_by_network_id(@network.id,
			:conditions => "DATE(dateandtime) <= '#{Date.today.strftime('%y-%m-%d')}'",
			:limit => 10, :order => "dateandtime DESC")
		@service = @services.first
		@attendances = Array.new()
		people = []
		@network.groups.each do |group|
			group.people.each do |person|
				people << person
			end
		end
		# Should this be useless? Shouldn't people be in only one group per network?
		people.uniq!
		people.sort! { |a, b| a.last_name <=> b.last_name }
		people.each do |person|
			@attendances << Attendance.find_or_create_by_person_id_and_service_id(person.id, @service.id,
				:include => [ :person, :status ])
		end
		@attendances = @attendances.select { |a| a.status != Status.find_by_designation('Present') }
		respond_to do |format|
			format.html # index.html.erb
			format.json { render :json => @attendances, :dasherize => false }
		end
	end

	def mark
		@attendance = Attendance.find(params[:id])
		@attendance.status = Status.find_by_designation('Present')
		respond_to do |format|
			if @attendance.save
				flash[:notice] = 'Attendance was successfully marked.'
			end
			format.json { render :json => @attendance }
		end
	end

end
