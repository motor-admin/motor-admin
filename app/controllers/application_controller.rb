# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :maybe_redirect_to_setup
  before_action :maybe_redirect_from_setup

  before_action :authenticate_admin_user!, unless: :setup_path?

  before_action do
    Devise::Mailer.default_url_options = { host: ENV['HOST'], protocol: request.protocol, port: request.port }
  end

  private

  def current_ability
    Motor::Ability.new(current_admin_user, request)
  end

  def maybe_redirect_to_setup
    return if setup_path?
    return unless new_setup?

    redirect_to admin_setup_path
  end

  def maybe_redirect_from_setup
    return unless setup_path?
    return if new_setup?

    redirect_to motor_admin_path
  end

  def new_setup?
    current_admin_user.nil? && Motor::AdminUser.count.zero?
  end

  def setup_path?
    request.path == admin_setup_path
  end
end
