module OmniAuth
  module Rails
    class Engine < Rails::Engine
      initialize "omniauth-rails.load_app_instance_data" do |app|

      OmniAuth::Rails.setup do |config|
        config.app_root = app.root
        initialize "omniauth-rails.load_static_assets" do |app|
        app.middleware.use ::ActionDispatch::Static, "#{root}/public"
      end
    end
  end
end
