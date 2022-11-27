# frozen_string_literal: true

class ImpersonateController < ApplicationController
  TOKEN_TTL = 1.hour
  SHA1_LENGTH = 40

  skip_before_action :authenticate_admin_user!

  def show
    sha1, payload = params[:token].unpack("a#{SHA1_LENGTH}a*")
    user_id, timestamp = JSON.parse(Base64.decode64([payload].pack('h*')))

    return head :forbidden if valid_token?(sha1, user_id, timestamp)
    return head :forbidden if Time.current - Time.zone.at(timestamp) > TOKEN_TTL

    user = Motor::AdminUser.find_by(id: user_id)

    return head :forbidden unless user

    sign_in(user)

    redirect_to motor_admin_path
  end

  private

  def valid_token?(sha1, user_id, timestamp)
    sha1 != Digest::SHA1.hexdigest(ENV['SECRET_KEY_BASE'].to_s + user_id.to_s + timestamp.to_s)
  end
end
