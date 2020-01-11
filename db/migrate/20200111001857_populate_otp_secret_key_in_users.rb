class PopulateOtpSecretKeyInUsers < ActiveRecord::Migration[5.2]
  def up
    User.find_each { |user| user.update_attribute(:otp_secret_key, User.otp_random_secret) }
  end

  def down
    User.update_all(:otp_secret_key, nil)
  end
end
