class AddMobileVerificationToEmployers < ActiveRecord::Migration
  def change
  	add_column :employers, :phone_confirmed, :boolean, :default => false
  	add_column :employers, :phone_verf_token, :string
  end
end
