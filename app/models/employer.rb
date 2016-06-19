class Employer < ActiveRecord::Base
  GENDER = [['Male',"male"],['Female',"female"]]
  enum state: [:unverified,:verified]

  validates :name, :presence => true
  validates :email, :presence => true, :uniqueness => true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :phone_number, :presence => true, :uniqueness => true
  validates_length_of :phone_number, :is => 10
  before_create :generate_confirmation_token, :generate_otp

  def send_verification_mail
    if self.confirm_token
      EmployerMailer.registration_confirmation(self).deliver_now
    end
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    self.verified! if self.can_verify?
    save
  end

  def send_otp
    if self.phone_verf_token
      url = URI("http://message.dalmiainfo.com/vendorsms/pushsms.aspx?user=incityventures&password=incity554&msisdn=%20919967470625&sid=ICVPVT&msg=Dear%20#{self.name}%2C%20your%20password%20is%20#{self.phone_verf_token}.&fl=0&gwid=2")
      http = Net::HTTP.new(url.host, url.port)
      request = Net::HTTP::Get.new(url)
      request["content-type"] = 'application/json'
      request["cache-control"] = 'no-cache'
      response = http.request(request)
    end
  end

  def verify_otp otp
    self.phone_activate if otp==self.phone_verf_token
  end

  def phone_activate
    self.phone_confirmed = true
    self.phone_verf_token = nil
    self.verified! if self.can_verify?
    save
  end

  def can_verify?
    self.phone_confirmed && self.email_confirmed
  end
  
  private
  def generate_confirmation_token
    self.confirm_token = SecureRandom.urlsafe_base64.to_s if self.confirm_token.blank?
  end

  def generate_otp
    self.phone_verf_token = "#{self.name[0..2].upcase}"+rand(1000..9999).to_s if self.phone_verf_token.blank?
  end

end
