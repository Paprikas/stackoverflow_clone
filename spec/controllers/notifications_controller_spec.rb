require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  let!(:question) { create(:question) }
  subject(:create_notification) { post :create, params: {question_id: question, format: :json} }
  subject(:delete_notification) { delete :destroy, params: {question_id: question, format: :json} }

  describe "POST #create" do
    context 'as user', :users, :auth do
      it "returns http success, assigns @notification", :aggregate_failures do
        create_notification
        expect(response).to have_http_status(:created)
        expect(assigns(:notification)).to eq Notification.last
      end

      it 'creates notification' do
        expect { create_notification }.to change(Notification, :count).by(1)
      end
    end

    context 'as guest' do
      it "returns http unauthorized" do
        create_notification
        expect(response).to have_http_status :unauthorized
      end

      it "doesn't creates notification" do
        expect { create_notification }.not_to change(Notification, :count)
      end
    end
  end

  describe "POST #destroy" do
    context 'as user', :users, :auth do
      before do
        create(:notification, user: user, question: question)
      end

      it "returns http success" do
        delete_notification
        expect(response).to have_http_status(:success)
      end

      # location???

      it "deletes notification" do
        expect { delete_notification }.to change(Notification, :count).by(-1)
      end
    end

    context 'as guest' do
      it "returns http unauthorized" do
        delete_notification
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
