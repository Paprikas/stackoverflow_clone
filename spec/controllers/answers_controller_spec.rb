require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:user_owned_answer) { create(:answer, question: question, user: user) }
  let(:answer) { create(:answer, question: question) }
  subject(:post_valid_answer) { post :create, params: {question_id: question, answer: attributes_for(:answer)} }
  subject(:delete_answer) { delete :destroy, params: {question_id: question, id: answer} }

  describe 'guest user' do
    describe 'PATCH #update' do
      it 'redirects to user login form'
    end

    describe 'POST #create' do
      it 'redirects to user login form' do
        post_valid_answer
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'DELETE #destroy' do
      it 'redirects to user login form' do
        delete_answer
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'authenticated user' do
    before { sign_in user }

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'creates new answer in the database' do
          expect {
            post_valid_answer
          }.to change(question.answers, :count).by(1)
        end

        it 'checks that answer belongs to user' do
          expect {
            post_valid_answer
          }.to change(user.answers, :count).by(1)
        end

        it 'redirects to @question' do
          post_valid_answer
          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        it "doesn't create new answer in the database" do
          expect {
            post :create, params: {question_id: question, answer: attributes_for(:invalid_answer)}
          }.not_to change(Answer, :count)
        end

        it 'renders new template' do
          post :create, params: {question_id: question, answer: attributes_for(:invalid_answer)}
          expect(response).to render_template 'questions/show'
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'owner of the answer' do
        it 'deletes answer from database' do
          user_owned_answer
          expect {
            delete :destroy, params: {question_id: question, id: user_owned_answer}
          }.to change(question.answers, :count).by(-1)
        end

        it 'redirects to @question' do
          delete :destroy, params: {question_id: question, id: user_owned_answer}
          expect(response).to redirect_to question
        end
      end

      context 'not owner of the answer' do
        it 'does not deletes answer from database' do
          answer
          expect {
            delete_answer
          }.not_to change(question.answers, :count)
        end

        it 'redirects to @question' do
          delete_answer
          expect(response).to redirect_to question
        end
      end
    end
  end
end
