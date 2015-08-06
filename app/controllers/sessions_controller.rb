class SessionsController < ApplicationController
  skip_before_filter :require_authenticated_user
  
  def try_login
    email = get_auth_provider_email
    unless email
      logger.warn "No email address in auth return"
      redirect_to(:back, :notice => "Login failed: Google didn't provide your email address.")
      return
    end
    if (u = User.find_by_email(email)) && u.authorized?
      session[:user_id] = u.id
      logger.warn "Authenticated #{email}"
      redirect_to conditions_path
    else
      session.delete(:user_id)
      logger.warn "#{email} is not an Instructor or Admin"
      redirect_to root_path, :notice => "Sorry, #{email} isn't an instructor or administrator."
    end
  end

  def login_failed
    redirect_to root_path, :notice => "Incorrect Google credentials."
  end

  def destroy
    session.delete(:user_id)
    @user = nil
    redirect_to root_path
  end

  protected

  def get_auth_provider_email
    if (hash = request.env['omniauth.auth']) &&
        (hash[:info].kind_of?(Hash))
      hash[:info][:email]
    else
      nil
    end
  end

end
