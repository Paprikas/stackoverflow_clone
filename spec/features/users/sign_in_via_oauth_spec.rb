require 'rails_helper'

shared_examples 'sign in via oauth' do
  given(:user) { create(:user) }

  background do
    OmniAuth.config.mock_auth[provider_sym] = nil
  end

  scenario 'new user' do
    mock_auth_hash(provider: provider_sym)
    visit new_user_session_path
    click_on "Sign in with #{provider_name}"
    expect(page).to have_content "Successfully authenticated from #{provider_name} account"
  end

  scenario 'with existing identity and email provided' do
    mock_auth_hash(provider: identity.provider, uid: identity.uid, info: {email: identity.user.email})
    visit new_user_session_path
    click_on "Sign in with #{provider_name}"
    expect(page).to have_content "Successfully authenticated from #{provider_name} account"
  end

  context 'without existing identity' do
    scenario 'with email provided' do
      mock_auth_hash(provider: provider_sym)
      visit new_user_session_path
      click_on "Sign in with #{provider_name}"
      expect(page).to have_content "Successfully authenticated from #{provider_name} account"
    end

    context 'without email' do
      # ??? split?
      scenario 'without email' do
        mock_auth_hash(provider: provider_sym, info: nil)

        visit new_user_session_path
        click_on "Sign in with #{provider_name}"

        expect(page).to have_content "Successfully authenticated from #{provider_name} account"
        expect(page).to have_content 'Please enter your email address to continue registration'

        fill_in 'Email', with: 'new@example.com'
        click_on 'Continue'

        expect(page).to have_content "Confirmation email sent to new@example.com"
        expect(page).to have_content 'Click here to resend confirmation instructions'
        expect(page).not_to have_selector '#user_email'
      end

      # ??? cant finish if above enabled (js)
      xscenario 'resend confirmation', :js do
        mock_auth_hash(provider: provider_sym, info: nil)

        visit new_user_session_path
        click_on "Sign in with #{provider_name}"
        sleep 0.5

        fill_in 'Email', with: 'new@example.com'
        click_on 'Continue'

        click_on 'Click here'
        fill_in 'Email', with: 'new_email@example.com'
        click_on 'Resend confirmation instructions'

        expect(page).to have_content 'Confirmation email sent to new_email@example.com, check your inbox and follow the instructions'
      end
    end
  end

  scenario 'view invalid_credentials error' do
    invalid_mock_auth_hash(provider_sym)
    visit new_user_session_path
    click_on "Sign in with #{provider_name}"
    sleep 0.5
    expect(page).to have_content 'Invalid credentials'
  end

  scenario 'view alert that registration is not finished' do
    mock_auth_hash(provider: provider_sym, info: nil)

    visit new_user_session_path
    click_on "Sign in with #{provider_name}"
    sleep 0.5
    expect(page).not_to have_content 'Your registration is not yet finished, please confirm your email address'
    visit root_path
    expect(page).to have_content 'Your registration is not yet finished, please confirm your email address'
    click_on 'confirm your email address'
    expect(page).not_to have_content 'Your registration is not yet finished, please confirm your email address'
    expect(page).to have_content 'Please enter your email address to continue registration'
  end

  scenario 'no alert for normal user' do
    mock_auth_hash(provider: provider_sym)

    visit new_user_session_path
    click_on "Sign in with #{provider_name}"
    sleep 0.5
    visit root_path
    expect(page).not_to have_content 'Your registration is not yet finished, please confirm your email address'
  end

  scenario 'user already exists, link with provider' do
    mock_auth_hash(provider: provider_sym, info: {email: user.email})

    visit new_user_session_path
    click_on "Sign in with #{provider_name}"
    expect(page).not_to have_content 'Please enter your email address to continue registration'
  end

  scenario 'email already taken' do
    mock_auth_hash(provider: provider_sym, info: nil)

    visit new_user_session_path
    click_on "Sign in with #{provider_name}"
    sleep 0.5

    fill_in 'Email', with: identity.user.email
    click_on 'Continue'
    expect(page).to have_content 'User with provided email already registered'
  end

  context 'confirmed' do
    background { sign_in user }

    scenario 'see success message' do
      visit finish_signup_path
      expect(page).to have_content 'Registration successfully finished'
    end
  end
end

feature 'Sign in via Oauth' do
  context 'facebook provider' do
    let(:provider_sym) { :facebook }
    let(:provider_name) { 'Facebook' }
    given!(:identity) { create(:identity, provider: provider_sym) }

    it_behaves_like 'sign in via oauth'
  end

  context 'twitter provider' do
    let(:provider_sym) { :twitter }
    let(:provider_name) { 'Twitter' }
    given!(:identity) { create(:identity, provider: provider_sym) }

    it_behaves_like 'sign in via oauth'
  end
end
