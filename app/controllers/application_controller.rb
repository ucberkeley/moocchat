class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all

  before_filter :require_authenticated_user

  protected

  def require_authenticated_user
    @user = User.find_by_id(session[:user_id]) # == nil if user_id is nil
    unless @user.try(:authorized?)
      flash[:notice] ||= 'You must be an Instructor or Administrator to do this action.'
      redirect_to root_path
    end
  end

end
