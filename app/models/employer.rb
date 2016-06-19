class Employer < ActiveRecord::Base
  GENDER = [['Male',"male"],['Female',"female"]]
  enum state: [:unverified,:verified]

  validates :email, :presence => true, :uniqueness => true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :phone_number, :presence => true, :uniqueness => true
  validates_length_of :phone_number, :is => 10
  before_create :confirmation_token

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end
  
  private
  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end
end
