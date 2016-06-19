class Employer < ActiveRecord::Base
  GENDER = [['Male',"male"],['Female',"female"]]
  enum state: [:unverified,:verified]

  validates :name, :presence => true
  validates :email, :presence => true, :uniqueness => true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :phone_number, :presence => true, :uniqueness => true
  validates_length_of :phone_number, :is => 10
  before_create :generate_confirmation_token, :generate_otp
  after_update :check_for_email_and_phone_changes, :if => proc {|k| k.email_changed? || k.phone_number_changed?}

  def send_verification_mail
    EmployerMailer.registration_confirmation(self).deliver_now if self.confirm_token
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    self.verified! if self.can_verify?
    self.save
  end

  def send_otp
    if self.phone_verf_token
      url = URI("http://message.dalmiainfo.com/vendorsms/pushsms.aspx?user=incityventures&password=incity554&msisdn=%20#{self.phone_number}&sid=ICVPVT&msg=Dear%20#{self.name}%2C%20your%20password%20is%20#{self.phone_verf_token}.&fl=0&gwid=2")
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
    self.save
  end

  def can_verify?
    self.phone_confirmed && self.email_confirmed
  end
  
  def generate_confirmation_token
    self.confirm_token = SecureRandom.urlsafe_base64.to_s if self.confirm_token.blank?
  end

  def generate_otp
    self.phone_verf_token = "#{self.name[0..2].upcase}"+rand(1000..9999).to_s if self.phone_verf_token.blank?
  end

  def check_for_email_and_phone_changes
    if self.email_changed? && self.phone_number_changed?
      self.resend_verf_email
      self.resend_otp
    elsif self.email_changed?
      self.resend_verf_email
    elsif self.phone_number_changed?
      self.resend_otp
    end
    self.unverified!
  end
  
  def resend_verf_email
    self.reload
    self.email_confirmed = false
    self.confirm_token = nil
    self.generate_confirmation_token
    self.save
    self.send_verification_mail
  end

  def resend_otp
    self.reload
    self.phone_confirmed = false
    self.phone_verf_token = nil
    self.generate_otp
    self.save
    self.send_otp
  end

end
