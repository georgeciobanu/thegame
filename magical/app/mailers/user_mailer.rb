class UserMailer < ActionMailer::Base
  default from: "mailer@lindenhoney.com"
  
  def info_email(subject, body, to)
    @emailBody = body
    @url = "http://www.lindenhoney.com"
    mail(:to => to, :subject => subject)
  end
  
  def welcome_email(email)
      @email = email.email
      @url  = "http://www.lindenhoney.com"
      mail(:to => email.email, :subject => "LindenHoney confirmation")
    end
end
