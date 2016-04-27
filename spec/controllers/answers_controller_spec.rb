require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:user_owned_answer) { create(:answer, question: question, user: user) }
  let(:answer) { create(:answer, question: question) }

  describe 'guest user' do
    describe 'GET #new' do
      it 'redirects to user login form' do
        get :new, params: {question_id: question}
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'PATCH #update' do
      it 'redirects to user login form'
    end

    describe 'POST #create' do
      it 'redirects to user login form' do
        post :create, params: {question_id: question, answer: attributes_for(:answer)}
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'DELETE #destroy' do
      it 'redirects to user login form' do
        delete :destroy, params: {question_id: question, id: answer}
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'authenticated user' do
    before { sign_in user }

    describe 'GET #new' do
      before do
        get :new, params: {question_id: question}
      end

      it 'assigns new answer @answer' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'creates new answer in the database' do
          expect {
            post :create, params: {question_id: question, answer: attributes_for(:answer)}
          }.to change(question.answers, :count).by(1)
        end

        it 'redirects to @question' do
          post :create, params: {question_id: question, answer: attributes_for(:answer)}
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
          expect(response).to render_template :new
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
            delete :destroy, params: {question_id: question, id: answer}
          }.not_to change(question.answers, :count)
        end

        it 'redirects to @question' do
          delete :destroy, params: {question_id: question, id: answer}
          expect(response).to redirect_to question
        end
      end
    end
  end
end
