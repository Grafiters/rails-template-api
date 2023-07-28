class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string    :email,                             limit: 150, null: false, :unique =>  true
      t.string    :password_digest
      t.string    :google_id,                         limit: 150, null: true, :unique =>  true
      t.string    :role,                              limit: 100, null: false, default: 'user', comment: 'user, therapist, admin'
      t.string    :email_verification_token,          limit: 150, null: false
      t.datetime  :email_verified_at,                 null: true
      t.string    :otp_secret,                        limit: 150, null: true
      t.boolean   :otp_enabled,                       default: false
      t.string    :reset_password_token,              limit: 150, null: true
      t.datetime  :verified_reset_password_token_at,  null: true

      t.timestamps
    end
  end
end
