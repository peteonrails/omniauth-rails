module OmniAuth
  module Rails
  	class AuthenticationsController < ::ApplicationController
  
	  before_filter :login_required, :except => [:create, :signin, :signup, :newaccount, :failure]
	  
	  protect_from_forgery :except => :create     # https://github.com/intridea/omniauth/issues/203

	  # GET all authentication authentications assigned to the current user
	  def index
	    @authentications = current_user.authentications.order('provider asc')
	  end

	  # POST to remove an authentication authentication
	  def destroy
	    # remove an authentication authentication linked to the current user
	    @authentication = current_user.authentications.find(params[:id])
	    
	    if session[:authentication_id] == @authentication.id
	      flash[:error] = 'You are currently signed in with this account!'
	    else
	      @authentication.destroy
	    end
	    
	    redirect_to authentications_path
	  end

	  # POST from signup view
	  def newaccount
	    if params[:commit] == "Cancel"
	      session[:authhash] = nil
	      session.delete :authhash
	      redirect_to root_url
	    else  # create account
	      @newuser = User.find_by_email(session[:authhash][:email]) || User.new(:name => session[:authhash][:name], :email => session[:authhash][:email], :password => Devise.friendly_token[0,20])
	      @newuser.authentications.build(:provider => session[:authhash][:provider], :uid => session[:authhash][:uid], :uname => session[:authhash][:name], :uemail => session[:authhash][:email])
	      
	      if @newuser.save!
	        # signin existing user
	        # in the session his user id and the authentication id used for signing in is stored
	        session[:user] = @newuser.id
	        session[:authentication_id] = @newuser.authentications.first.id
	        
	        flash[:notice] = 'Your account has been created and you have been signed in!'
	        redirect_to root_url
	      else
	        flash[:error] = 'This is embarrassing! There was an error while creating your account from which we were not able to recover.'
	        redirect_to root_url
	      end  
	    end
	  end  
	  
	  # Sign out current user
	  def signout 
	    if current_user
	      session[:identity] = nil
	      session[:authentication_id] = nil
	      session.delete :identity
	      session.delete :authentication_id
	      flash[:notice] = 'You have been signed out!'
	    end  
	    redirect_to root_url
	  end
	  
	  # callback: success
	  # This handles signing in and adding an authentication authentication to existing accounts itself
	  # It renders a separate view if there is a new user to create
	  def create
	    # get the authentication parameter from the Rails router
	    params[:provider] ? authentication_route = params[:provider] : authentication_route = 'No authentication recognized (invalid callback)'

	    # get the full hash from omniauth
	    omniauth = request.env['omniauth.auth']
	    
	    # continue only if hash and parameter exist
	    if omniauth and params[:provider] == 'identity'
	      # in the session his user id and the authentication id used for signing in is stored
	      session[:identity] = omniauth['uid']
	      redirect_to root_url, :notice => "Signed in successfully."
	      
	    elsif omniauth and params[:provider]
	      # create a new hash
	      @authhash = Hash.new
	      if authentication_route == 'google_oauth2'
	        omniauth['info']['email'] ? @authhash[:email] =  omniauth['info']['email'] : @authhash[:email] = ''
	        omniauth['info']['name'] ? @authhash[:name] =  omniauth['info']['name'] : @authhash[:name] = ''
	        omniauth['uid'] ? @authhash[:uid] =  omniauth['uid'].to_s : @authhash[:uid] = ''
	        omniauth['provider'] ? @authhash[:provider] =  omniauth['provider'] : @authhash[:provider] = ''
	      else        
	        # debug to output the hash that has been returned when adding new authentications
	        render :text => omniauth.to_yaml
	        return
	      end
	      
	      if @authhash[:uid] != '' and @authhash[:provider] != ''
	        auth = Authentication.find_by_provider_and_uid(@authhash[:provider], @authhash[:uid])
	        # if the user is currently signed in, he/she might want to add another account to signin
	        if logged_in?
	          if auth
	            flash[:notice] = 'Your account at ' + @authhash[:provider].capitalize + ' is already connected with this site.'
	            redirect_to authentications_path
	          else
	            current_user.authentications.create!(:provider => @authhash[:provider], :uid => @authhash[:uid], :uname => @authhash[:name], :uemail => @authhash[:email])
	            flash[:notice] = 'Your ' + @authhash[:provider].capitalize + ' account has been added for signing in at this site.'
	            redirect_to authentications_path
	          end
	        else
	          if auth
	            # signin existing user
	            # in the session his user id and the authentication id used for signing in is stored
	            session[:user] = auth.user.id
	            session[:authentication_id] = auth.id
	          
	            flash[:notice] = 'Signed in successfully.'
	            redirect_to root_url
	          else
	            # this is a new user; show signup; @authhash is available to the view and stored in the sesssion for creation of a new user
	            if Rails.env == "development" or @authhash[:email].split('@').include?('intridea.com')
	              session[:authhash] = @authhash
	              render signup_authentications_path
	            end
	            # render signup_authentications_path
	          end
	        end
	      else
	        flash[:error] =  'Error while authenticating via ' + authentication_route + '/' + @authhash[:provider].capitalize + '. The authentication returned invalid data for the user id.'
	        redirect_to login_path
	      end
	    else
	      flash[:error] = 'Error while authenticating via ' + authentication_route.capitalize + '. The authentication did not return valid data.'
	      redirect_to login_path
	    end
	  end
	  
	  # callback: failure
	  def failure
	    flash[:error] = 'There was an error. You have not been signed in.'
	    redirect_to root_url
	  end
  	end
  end
end
