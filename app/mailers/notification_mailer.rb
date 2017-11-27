class NotificationMailer < ApplicationMailer
  default from: "st119370@ait.asia"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.notification.subject
  #
  def notification(mail_id)
    @mail = mail_id
    @greeting = "Hi"

    mail to: @mail, subject: "Test Mail. Dont reply!!! "
  end
end
