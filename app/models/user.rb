class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :identities, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  def self.find_with_oauth(auth)
    identity = Identity.find_by(provider: auth.provider, uid: auth.uid)
    return identity.user if identity
    user = User.find_by(email: auth.info['email'])
    if user
      user.identities.create(provider: auth.provider, uid: auth.uid)
    else
      # ??? return create_user_from_auth(auth)
      user = create_user_from_auth(auth)
    end
    user
  end

  private

  # need test?
  def self.create_user_from_auth(auth)
    password = Devise.friendly_token[0, 20]
    user = create!(email: auth.info['email'], password: password)
    user.identities.create(provider: auth.provider, uid: auth.uid)
    user
  end
end
