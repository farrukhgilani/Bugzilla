class ApplicationController < ActionController::Base
     before_action :authenticate_user!
     include Pundit::Authorization
     rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  protect_from_forgery with: :exception
  helper_method :current_user

     before_action :configure_permitted_parameters, if: :devise_controller?

     protected

          def configure_permitted_parameters
               devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :user_type)}

               devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password)}
          end




     private

       def user_not_authorized
         flash[:warning] = "You are not authorized to perform this action."
         redirect_to(request.referrer || root_path)
       end

end
