require "omniauth-rails/version"
require "active_support/dependencies"

module OmniAuth
  module Rails
    mattr_accessor :app_root
    def self.setup
      yield self
    end
  end
end

require "omniauth-rails/engine"
