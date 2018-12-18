# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update, :profile_update]
  before_action :authenticate_user!

#  def profile_edit
#  end

  #松田変更ここから
  #def profile_update
  #  if current_user.update_attributes(account_update_params)
  #    redirect_to current_user, success: "プロフィールを更新しました。"
  #  else
  #    render "profile_edit"
  #  end
  #end

  def edit
    set_mode
    super
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      bypass_sign_in resource, scope: resource_name
#      respond_with resource, location: after_update_path_for(resource)
      redirect_to current_user, success: "プロフィールを更新しました。"
    else
      clean_up_passwords resource
      set_minimum_password_length
#      respond_with resource
      edit
    end
  end
  #松田変更ここまで

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

#松田変更ここから

    # deviseの設定を変更するためオーバーライド
#   def update_resource(resource, params)
#      resource.update_without_current_password(params)
#   end

protected
  def set_mode
    if (!params[:user].nil? && params[:user][:mode] == "profile") || (params[:user].nil? && params[:mode].nil?) || (params[:mode] == "profile") then
      @mode = "profile"
    else
      @mode = "password"
    end
  end

  def update_resource(resource, params)
    if params[:password].present? && params[:password_confirmation].present?
      resource.update_attributes(params)
    else
      resource.update_without_password(params)
    end
  end

#松田変更ここまで
private
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:user_name])
  end
end
