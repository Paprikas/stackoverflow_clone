require 'rails_helper'

describe RegistrationsController, type: :controller do
  describe 'GET #finish_signup' do
    context 'as guest' do
      it 'redirects to new_user_session_path' do
        get :finish_signup
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'as user' do
      context 'confirmed' do
        let(:user) { create(:user) }

        before do
          sign_in user
          get :finish_signup
        end

        it { should redirect_to root_path }
      end

      context 'unconfirmed' do
        let(:user) { create(:user, confirmed_at: nil) }

        before do
          sign_in user
          get :finish_signup
        end

        it { should render_template :finish_signup }
      end
    end
  end

  describe 'PATCH #send_confirmation_email' do
    context 'as guest' do
      it 'redirects to new_user_session_path' do
        patch :send_confirmation_email
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'as user' do
      context 'confirmed' do
        let(:user) { create(:user) }

        before do
          sign_in user
          patch :send_confirmation_email
        end

        it { should redirect_to root_path }
      end

      context 'unconfirmed' do
        let(:user) { create(:user, confirmed_at: nil) }
        subject(:patch_with_test_email) { patch :send_confirmation_email, params: {user: {email: 'test@example.com'}} }

        before do
          sign_in user
        end

        it 'redirects to finish_signup' do
          patch_with_test_email
          expect(response).to redirect_to :finish_signup
        end

        it 'sets flash with that user exists' do
          user = create(:user)
          patch :send_confirmation_email, params: {user: {email: user.email}}
          expect(controller).to set_flash[:notice].to 'User with provided email already registered'
        end

        it 'sets flash with that email sent' do
          patch_with_test_email
          expect(controller).to set_flash[:notice].to 'Confirmation email successfully sent'
        end

        it 'updates unconfirmed email' do
          patch_with_test_email
          user.reload
          expect(user.unconfirmed_email).to eq 'test@example.com'
        end
      end
    end
  end
end
