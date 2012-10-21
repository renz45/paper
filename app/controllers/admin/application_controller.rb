class Admin::ApplicationController < ActionController::Base
  layout 'admin/application'
  protect_from_forgery
  before_filter :authenticate_user!
end
