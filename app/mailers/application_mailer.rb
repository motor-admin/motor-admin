# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'reports@getmotoradmin.com'
  layout 'mailer'
end
