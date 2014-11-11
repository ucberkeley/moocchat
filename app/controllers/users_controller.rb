class UsersController < ApplicationController
  def record_consent
    render(:nothing => true, :status => 403) and return unless request.xhr?
    users = User.where(['name = ?', params[:username]])
    if users.empty?
      @user = Learner.new(name: params[:username])
    else
      @user = users.first
    end
    @user.update_attribute(:consent, params[:consent])
    @user.update_attribute(:consent_timestamp, Time.current.utc)
    render :nothing => true
  end

  def check_consent
    render(:nothing => true, :status => 403) and return unless request.xhr?
    users = User.where(['name = ?', params[:username]])
    if !users.empty?
      @user = users.first
    end
    if users.empty? || @user.consent.nil? || @user.consent_timestamp.nil?
      response = {completed: false}
    elsif @user.consent==1 || @user.consent==true
      response = {completed: true, consented: true}
    else
      response = {completed: true, consented: false}
    end
    render :json => response.to_json, :callback => params['callback']
  end
end
