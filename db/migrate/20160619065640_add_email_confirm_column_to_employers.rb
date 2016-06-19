class AddEmailConfirmColumnToEmployers < ActiveRecord::Migration
  def change
  	add_column :employers, :email_confirmed, :boolean, :default => false
  	add_column :employers, :confirm_token, :string
  end
end
