# frozen_string_literal: true

class UiController < ApplicationController
  helper_method :app_data_attributes

  def index
    render :show
  end

  def show; end

  private

  def app_data_attributes
    {
      version: Motor::VERSION,
      base_path: Rails.application.routes.url_helpers.motor_admin_path,
      current_user: current_admin_user.as_json(only: %i[id email first_name last_name])
    }
  end
end
