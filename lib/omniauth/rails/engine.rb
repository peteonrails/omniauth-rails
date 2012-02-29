module OmniAuth::Rails
  
  class Engine < Rails::Engine
    # engine_name 'omniauth-rails' # deprecated 
    config.autoload_paths += %W(#{config.root}/lib #{config.root}/services)

    initializer "omniauth-rails.load_static_assets" do |app|
      app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{config.root}/public"
    end

    initializer "omniauth-rails.load_app_instance_data" do |app|
      OmniAuth::Rails.setup do |config|
        config.app_root = app.root
      end
    end
  end
end
