class Employer < ActiveRecord::Base
  GENDER = [['Male',"male"],['Female',"female"]]
  enum state: [:unverified,:verified]

  validates :email, :presence => true, :uniqueness => true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :phone_number, :presence => true, :uniqueness => true
  validates_length_of :phone_number, :is => 10
end
