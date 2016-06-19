class EmployerMailer < ActionMailer::Base
  default :from => "shahi.shaurya@gmail.com"

  def registration_confirmation(employer)
    @employer = employer
    data = {
      template_id: "verify",
      substitution_data: {
        user_name: @employer.name,
        user_email: @employer.email,
        link: confirm_email_employer_url(@employer.confirm_token)
      }
    }
    mail(to: @employer.email, sparkpost_data: data) do |format|
      format.text { render text: "" }
    end
  end

end