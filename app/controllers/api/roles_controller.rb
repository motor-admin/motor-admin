# frozen_string_literal: true

module Api
  class RolesController < ApiBaseController
    load_and_authorize_resource class: 'Motor::Role'

    def index
      render json: { data: @roles.order(:id) }
    end

    def create
      if @role.save!
        render json: { data: @role }
      else
        render json: { errors: @role.errors.as_json }, status: :unprocessable_entity
      end
    end

    def update
      if @role.update(role_params)
        render json: { data: @role }
      else
        render json: { errors: @admin_user.errors.as_json }, status: :unprocessable_entity
      end
    end

    def destroy
      @role.destroy!

      head :ok
    end

    private

    def role_params
      params.require(:role).permit(:name, rules: [{
                                     subjects: [],
                                     actions: [],
                                     attributes: [],
                                     conditions: [:key, { value: [] }]
                                   }])
    end
  end
end
