class ApplicationController < ActionController::Base
  protect_from_forgery
  enju_leaf
  enju_biblio
  enju_library
  enju_event
  after_action :verify_authorized

  include Pundit
end
