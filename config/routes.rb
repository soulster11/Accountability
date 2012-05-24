Accountability::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  resources :schedules

  resources :networks

	match 'users/change', :controller => 'users', :action => 'change'
	match 'users/reset', :controller => 'users', :action => 'reset'
	match 'users/login', :controller => 'users', :action => 'login'
	match 'users/logout', :controller => 'users', :action => 'logout'
	resources :users

	match 'people/directory', :controller => 'people', :action => 'directory'
	match 'people/directory.pdf', :controller => 'people', :action => 'directory', :format => 'pdf'
	match 'people/ungrouped', :controller => 'people', :action => 'ungrouped'
	match 'people/uncontactable', :controller => 'people', :action => 'uncontactable'
	match 'people/mobile', :controller => 'people', :action => 'mobile'
	resources :people

	resources :residences

	match 'attendances/take', :controller => 'attendances', :action => 'take'
	match 'attendances/mobile', :controller => 'attendances', :action => 'mobile'
	match 'attendances/followup', :controller => 'attendances', :action => 'followup'
	match 'attendances/report', :controller => 'attendances', :action => 'report'
	match 'attendances/history', :controller => 'attendances', :action => 'history'
	match 'attendances/lookup', :controller => 'attendances', :action => 'lookup'
	match 'attendances/old', :controller => 'attendances', :action => 'old'
	match 'attendances/choose', :controller => 'attendances', :action => 'choose'
	match 'attendances/register', :controller => 'attendances', :action => 'register'
	match 'attendances/change_group_take', :controller => 'attendances', :action => 'change_group_take'
	match 'attendances/change_date_take', :controller => 'attendances', :action => 'change_date_take'
	resources :attendances do
		member do
			get 'mark'
		end
	end

	resources :users

	resources :services

	resources :groups

	resources :people
	
  root :to => 'attendances#take'

end
