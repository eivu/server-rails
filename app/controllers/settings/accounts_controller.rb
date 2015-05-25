class Settings::AccountsController < SettingsController

  def update
    begin
      #if password stuff is blank that means we are not trying to reset the password, so remove the keys from params
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      current_user.update_attributes! params[:user].permit(:password, :password_confirmation, :access_key_id, :secret_access_key)
      flash[:success] = "Account has been updated"
    rescue ActiveRecord::RecordInvalid => error
      flash[:notice] = error.message
    end
    redirect_to settings_account_path
  end
end