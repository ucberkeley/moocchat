class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all
  def getSession
  	session 
  end
end