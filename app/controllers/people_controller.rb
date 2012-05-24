class PeopleController < ApplicationController
	
	before_filter :admin_required, :except => [ :directory ]
	
	cattr_reader :per_page
  @@per_page = 10

	# GET /people
	# GET /people.xml
	def index
		#@people = Person.all(:order => "last_name, first_name", :include => :type)
		@people = Person.paginate :page => params[:page], :order => 'last_name, first_name',
			:include => :type

		respond_to do |format|
			format.html # index.html.erb
			format.xml	{ render :xml => @people }
		end
	end

	# GET /people/1
	# GET /people/1.xml
	def show
		@person = Person.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.xml	{ render :xml => @person }
		end
	end

	# GET /people/new
	# GET /people/new.xml
	def new
		@person = Person.new
		@residences = Residence.find(:all, :order => :address1)
		@heads = Person.find(:all, :conditions => "type_id = 1",
			:order => "last_name, first_name")
		respond_to do |format|
			format.html # new.html.erb
			format.xml	{ render :xml => @person }
		end
	end

	# GET /people/1/edit
	def edit
		@person = Person.find(params[:id])
		@residences = Residence.find(:all, :order => :address1)
		@heads = Person.find(:all, :conditions => "type_id = 1",
			:order => "last_name, first_name")
	end

	# POST /people
	# POST /people.xml
	def create
		@person = Person.new(params[:person])

		respond_to do |format|
			if @person.save
				flash[:notice] = 'Person was successfully created.'
				format.html { redirect_to(@person) }
				format.xml	{ render :xml => @person, :status => :created, :location => @person }
			else
				format.html { render :action => "new" }
				format.xml	{ render :xml => @person.errors, :status => :unprocessable_entity }
			end
		end
	end

	# PUT /people/1
	# PUT /people/1.xml
	def update
		@person = Person.find(params[:id])
		@person.picture = nil if params[:delete_picture]
		@residences = Residence.find(:all, :order => :address1)
		@heads = Person.find(:all, :conditions => "type_id = 1",
			:order => "last_name, first_name")
		respond_to do |format|
			if @person.update_attributes(params[:person])
				flash[:notice] = 'Person was successfully updated.'
				format.html { redirect_to(@person) }
				format.xml	{ head :ok }
			else
				format.html { render :action => "edit" }
				format.xml	{ render :xml => @person.errors, :status => :unprocessable_entity }
			end
		end
	end

	# DELETE /people/1
	# DELETE /people/1.xml
	def destroy
		@person = Person.find(params[:id])
		@person.destroy

		respond_to do |format|
			format.html { redirect_to(people_url) }
			format.xml	{ head :ok }
		end
	end

	def directory
		@heads = Person.find_all_by_type_id(1, :order => "last_name, first_name",
			:include => [ :children, :residence ])
		respond_to do |format|
			format.html
			format.pdf do
				render :pdf => 'directory', :template => 'people/directory.pdf.erb',
					:layout => 'pdf.html'
			end
		end
	end

	def ungrouped
		@ungrouped = Person.all(:conditions => "type_id != 3",
			:order => "last_name, first_name").select { |p| p.groups.empty? }
	end
	
	def uncontactable
		@uncontactable = Person.all(:order => "last_name, first_name").select { |p|
			(p.residence.nil? || p.residence.phone_number.nil?) && p.cell_number.nil? &&
	 		p.email_address.nil? }
	end
	
end
