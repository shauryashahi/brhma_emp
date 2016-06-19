class EmployerMailer < ActionMailer::Base

  def registration_confirmation(employer)
    @employer = employer
    mail(to: @employer.email, subject: "Email Verification - BrahmaEmployers")
  end

end