Site::Application.routes.draw do

  resource :page, path: "", only: [] do
    get :contact
    get :about
    get :help
    get :blog
    get :press
    get :signin
    get :home
  end

  root :to => 'pages#home'

  controller :session do
    post '/login'  => :create
    post '/logout' => :destroy, as: :logout
    post '/newpass' => :newpass, as: :newpass
  end

  controller :user do
    get  '/register' => :new, as: :registration
    post '/register' => :create
    get  '/profile'  => :show, as: :profile
    get  '/update'   => :update, as: :update
    get  '/edit'     => :edit, as: :edit
  end

  namespace :dareforget, as: nil do
    get "/" => :index, as: :dareforget
    resources :items, except: :new do
      collection do
        get :available
      end
      new do
        get ":id" => :new, as: ""
      end
    end
  end

  namespace :stillalive, as: nil do
    get "/" => :index, as: :stillalive
    resources :contacts, except: :new do
      collection do
        post ":id" => :reset, as: :reset
      end
    end
  end

  namespace :foodchain, as: nil do
    get "/" => :show, as: :foodchain
    get "/planning" => :generate_planning, as: :planning
    get "/recipe_details/:id" => :recipe_details, as: :details
    get "/create" => :create
    get "/new" => :new, as: :creation
    get "/search" => :search_recipe, as: :search
    get "/recipe_all" => :all_recipe, as: :allrecipe
  end

  namespace :dontpanic do
    get :search
    get :results
    get :categories
    get :update
    get "category/:id" => :category, as: :category
    get "" => :index
    get ":id(/:page)" => :show, as: :tutorial
    post ":id" => :download, as: :download
    delete ":id" => :delete, as: :delete
  end
end
