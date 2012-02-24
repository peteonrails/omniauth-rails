class OmniAuth::Rails::Authentication < ActiveRecord::Base
	belongs_to :identity
end
