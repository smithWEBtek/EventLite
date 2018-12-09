class User < ApplicationRecord
    has_many :attendances
    has_many :events, :through => :attendances

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { in: 6..100 }

    has_secure_password

    def member_since
        self.created_at.strftime("%B %Y")
    end

     def self.find_or_create_by_omniauth(auth_hash)
        self.where(:email => auth_hash[:info][:email]).first_or_create do |user|
            user.password = SecureRandom.hex
        end
    end 
end