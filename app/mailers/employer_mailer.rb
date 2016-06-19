class EmployerMailer < ActionMailer::Base
    default :from => "shahi.shaurya@gmail.com"

 def registration_confirmation(employer)
    @employer = employer
    mail(:to => "#{employer.name} <#{employer.email}>", :subject => "Registration Confirmation")
 end