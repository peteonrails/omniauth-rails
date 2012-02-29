require "omniauth/rails/version"

module OmniAuth
  module Rails
    mattr_accessor :app_root
    def self.setup
      yield self
    end
  end
end

require "omniauth/rails/engine"
