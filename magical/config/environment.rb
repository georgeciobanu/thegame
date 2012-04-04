# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Magical::Application.initialize!

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address        => "smtp.gmail.com",
  :port           => 587,
  :domain         => "gmail.com",
  :user_name      => "mailer@lindenhoney.com",
  :password       => "1ntr0ducere",
  :authentication => "plain",
  :enable_starttls_auto =>true
}

ActionMailer::Base.raise_delivery_errors = true