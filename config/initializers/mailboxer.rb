Mailboxer.setup do |config|

  # Configures if you application uses or not email sending for Notifications and Messages
  config.uses_emails = true # TODO Will be set to true

  # Configures the default from for emails sent for Messages and Notifications
  config.default_from = "hello@seaforall.com"

  # Configures the methods needed by mailboxer
  config.email_method = :mailboxer_email
  config.name_method = :name

  config.notification_mailer = BookingNotificationMailer
  config.message_mailer = BookingMessageMailer

  # Use delayed_jobs for sending the email
  # from https://github.com/mailboxer/mailboxer/issues/189
  config.custom_deliver_proc = ->(mailer, mailable, recipient) do
    mailer.delay.send_email(mailable, recipient, I18n.locale)
  end

  # Configures if you use or not a search engine and which one you are using
  # Supported engines: [:solr,:sphinx]
  config.search_enabled = false
  config.search_engine = :solr

  # Configures maximum length of the message subject and body
  config.subject_max_length = 255
  config.body_max_length = 32000
end
