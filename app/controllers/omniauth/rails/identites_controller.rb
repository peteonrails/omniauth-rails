module OmniAuth
  module Rails
    class IdentitiesController < ApplicationController

      protect_from_forgery :except => :create     # https://github.com/intridea/omniauth/issues/203

      def new
        @identity = env['omniauth.identity']
      end

      # Sign out current user
      def destroy
        if current_user
          session[:identity] = nil
          session[:authentication_id] = nil
          session.delete :identity
          session.delete :authentication_id
          flash[:notice] = 'You have been signed out!'
        end
        redirect_to root_url
      end

      # callback: failure
      def failure
        flash[:error] = 'There was an error at the remote authentication. You have not been signed in.'
        redirect_to login_url
      end
    end
  end
end