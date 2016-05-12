class User < ApplicationRecord
  TEMP_EMAIL_PREFIX = 'change@me'.freeze # ???
  TEMP_EMAIL_REGEX = /\Achange@me/

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :identities, dependent: :destroy

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  def self.find_for_oauth(auth)
    email = auth.try(:info).try(:email) # ???
    user = find_by(email: email) if email
    if user.present?
      user.create_identities(auth)
    else
      user = create_user_from_auth(auth)
    end
    user
  end

  def self.create_user_from_auth(auth)
    email = auth.try(:info).try(:email) ? auth.info.email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
    user = new(email: email, password: Devise.friendly_token[0, 20])
    user.skip_confirmation! if auth.try(:info).try(:email)
    user.save!
    user.create_identities(auth)
    user
  end

  def email_verified?
    email && email !~ TEMP_EMAIL_REGEX
  end

  def create_identities(auth)
    identities.create(provider: auth.provider, uid: auth.uid)
  end
end
