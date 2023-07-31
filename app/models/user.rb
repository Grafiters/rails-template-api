class User < ApplicationRecord
    validates :email, presence: true, uniqueness: true

    before_validation :assignment_email_verified_token

    class << self
        def from_auth_google(payload)
            user = User.find_or_create_by({email: payload.email, google_id: payload.id})
            user.save!
            user
        end
    end

    def as_fot_jwt_token
        {
            email: email,
            google_id: google_id,
            role: role
        }
    end

    private
    def assignment_email_verified_token
        self.email_verification_token = 6.times.map{rand(10)}.join unless email_verification_token
    end
end