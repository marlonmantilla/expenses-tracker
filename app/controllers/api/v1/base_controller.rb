class Api::V1::BaseController < ActionController::Base
	protect_from_forgery with: :null_session
	before_action :authenticate


	protected

	def authenticate	
		authenticate_basic_auth || render_unauthorized	
	end	
	 
	def authenticate_basic_auth	
		authenticate_with_http_basic do |email, password|	
			resource = User.find_by_email(email)
      if resource.valid_password?(password)
        sign_in :user, resource
      end
		end	
	end	

	def render_unauthorized	
		respond_to do |format|	
			format.json { render json: 'Bad credentials', status: 401 }	
			format.xml { render xml: 'Bad credentials', status: 401 }	
		end	
	end	

end
	