class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # THIS LINE WORKS IF ALL ELSE FAILS
      # sign_in(@user)
      # @user.save
      # redirect_to fb_details_new_path, notice: 'Enter details to proceed.'
      # redirect_to new_user_registration_path, notice: 'Signed in successfully.'
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_path
    end
  end

  def failure
    redirect_to home_index_path
  end
end