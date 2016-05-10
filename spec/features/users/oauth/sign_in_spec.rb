require 'rails_helper'

feature 'Sign in via facebook' do
  given!(:identity) { create(:identity) }

  scenario 'Sign in' do
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(provider: identity.provider,
                                                                  uid: identity.uid,
                                                                  info: {email: identity.user.email}
                                                                 )
    visit new_user_session_path
    click_on 'Sign in with Facebook'
    expect(page).to have_content 'Successfully authenticated from Facebook account'
  end
end
