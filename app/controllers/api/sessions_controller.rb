# frozen_string_literal: true

module Api
  class SessionsController < ApiBaseController
    skip_authorization_check

    def destroy
      sign_out current_admin_user

      head :ok
    end
  end
end
