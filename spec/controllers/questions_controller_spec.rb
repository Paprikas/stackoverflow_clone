require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  # DHH on testing templates and vars in controller
  # https://github.com/rails/rails/issues/18950

  shared_examples 'public access' do
    describe 'GET #index' do
      before { get :index }

      it 'assigns questions to @questions' do
        questions = create_pair(:question)
        expect(assigns(:questions)).to match_array(questions)
      end

      it 'renders index template' do
        expect(response).to render_template :index
      end
    end

    describe 'GET #show' do
      let(:question) { create(:question) }
      before { get :show, params: {id: question} }

      it 'assigns question to @question' do
        expect(assigns(:question)).to eq(question)
      end

      it 'renders show template' do
        expect(response).to render_template :show
      end
    end
  end

  describe 'guest user' do
    let(:question) { create(:question) }
    it_behaves_like 'public access'

    describe 'GET #new' do
      it 'redirects to user login form' do
        get :new
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'PATCH #update' do
      it 'redirects to user login form'
    end

    describe 'POST #create' do
      it 'redirects to user login form' do
        post :create
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'DELETE #destroy' do
      it 'redirects to user login form' do
        delete :destroy, params: {id: question}
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'authenticated user' do
    let(:user) { create(:user) }
    let(:user_owned_question) { create(:question, user: user) }
    let(:question) { create(:question) }
    before { sign_in user }

    it_behaves_like 'public access'

    describe 'GET #new' do
      before { get :new }

      it 'assigns new question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'renders new template' do
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'creates new question in the database' do
          expect {
            post :create, params: {question: attributes_for(:question)}
          }.to change(user.questions, :count).by(1)
        end

        it 'redirects to @question' do
          post :create, params: {question: attributes_for(:question)}
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it "doesn't create new question in the database" do
          expect {
            post :create, params: {question: attributes_for(:invalid_question)}
          }.not_to change(Question, :count)
        end

        it 'renders new template' do
          post :create, params: {question: attributes_for(:invalid_question)}
          expect(response).to render_template :new
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'owner of the question' do
        it 'deletes question from database' do
          user_owned_question
          expect {
            delete :destroy, params: {id: user_owned_question}
          }.to change(user.questions, :count).by(-1)
        end

        it 'deletes dependent answers from database' do
          create(:answer, question: user_owned_question)
          expect {
            delete :destroy, params: {id: user_owned_question}
          }.to change(Answer, :count).by(-1)
        end

        it 'redirects to root_path' do
          delete :destroy, params: {id: user_owned_question}
          expect(response).to redirect_to root_path
        end
      end

      context 'not owner of the question' do
        it 'does not deletes question from database' do
          question
          expect {
            delete :destroy, params: {id: question}
          }.not_to change(Question, :count)
        end

        it 'redirects to @question' do
          delete :destroy, params: {id: question}
          expect(response).to redirect_to question
        end
      end
    end
  end
end
