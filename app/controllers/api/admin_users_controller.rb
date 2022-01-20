# frozen_string_literal: true

module Api
  class AdminUsersController < ApiBaseController
    before_action :build_admin_user, only: :create
    load_and_authorize_resource class: 'Motor::AdminUser'

    def index
      render json: serialized_user_data(
        @admin_users.preload(:roles).where(deleted_at: nil).order(:id)
      )
    end

    def show
      render json: serialized_user_data(@admin_user)
    end

    def create
      if @admin_user.save!
        render json: serialized_user_data(@admin_user)
      else
        render json: { errors: @admin_user.errors.as_json }, status: :unprocessable_entity
      end
    end

    def update
      if @admin_user.update(admin_user_params)
        render json: serialized_user_data(@admin_user)
      else
        render json: { errors: @admin_user.errors.as_json }, status: :unprocessable_entity
      end
    end

    def destroy
      @admin_user.update!(deleted_at: Time.current)

      head :ok
    end

    def reset_password
      @admin_user = Motor::AdminUser.find(params[:admin_user_id])

      authorize!(:manage, @admin_user)

      Devise::Mailer.default_url_options = { host: ENV['HOST'], protocol: request.protocol, port: request.port }

      @admin_user.send_reset_password_instructions

      head :ok
    end

    private

    def build_admin_user
      @admin_user   = Motor::AdminUser.find_by(email: admin_user_params[:email])
      @admin_user ||= Motor::AdminUser.new(admin_user_params.merge(roles: [Motor::Role.admin]))

      @admin_user.assign_attributes(admin_user_params.merge(deleted_at: nil))
    end

    def serialized_user_data(user)
      {
        data: user.as_json(only: %i[id email first_name last_name locked_at], include: %i[roles])
      }
    end

    def admin_user_params
      params.require(:admin_user).permit(:email, :first_name, :last_name, :password)
    end
  end
end
