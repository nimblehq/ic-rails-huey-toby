# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Localization
  include DoorkeeperAuthentication
end
