# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'sgilani@devsinc.com'
  layout 'mailer'
end
