require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  subject(:vote_up) { post :vote_up, xhr: true, params: {id: question} }
  subject(:vote_down) { post :vote_down, xhr: true, params: {id: question} }

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
      it 'shows first in list if accepted' do
        question = create(:question)
        answer = create(:answer, question: question)
        accepted_answer = create(:answer, question: question, accepted: true)

        get :show, params: {id: question}
        expect(question.answers).to eq([accepted_answer, answer])
      end
    end
  end

  describe 'guest user' do
    it_behaves_like 'public access'

    describe 'GET #show' do
      before { get :show, params: {id: question} }

      it 'assigns question to @question' do
        expect(assigns(:question)).to eq(question)
      end

      it 'renders show template' do
        expect(response).to render_template :show
      end
    end

    describe 'GET #new' do
      it 'redirects to user login form' do
        get :new
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'PATCH #update' do
      it 'responses with 401' do
        patch :update, xhr: true, params: {id: question}
        expect(response.status).to eq 401
      end
    end

    describe 'POST #vote' do
      it 'responses with 401' do
        vote_up
        expect(response.status).to eq 401
      end
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
    before { sign_in user }

    it_behaves_like 'public access'

    describe 'GET #show' do
      before { get :show, params: {id: question} }

      it 'assigns question to @question' do
        expect(assigns(:question)).to eq(question)
      end

      it 'assigns answer to @answer' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it 'builds attachment' do
        expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
      end

      it 'renders show template' do
        expect(response).to render_template :show
      end
    end

    describe 'GET #new' do
      before { get :new }

      it 'assigns new question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'builds attachment' do
        expect(assigns(:question).attachments.first).to be_a_new(Attachment)
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

    describe 'PATCH #update' do
      context 'owner of the question' do
        before { user_owned_question }

        context 'with valid attributes' do
          it 'renders update template' do
            patch :update, xhr: true, params: {id: user_owned_question, question: attributes_for(:question)}
            expect(response).to render_template :update
          end

          it 'updates question' do
            patch :update, xhr: true, params: {id: user_owned_question, question: {title: 'New title', body: 'New body'}}
            user_owned_question.reload
            expect(user_owned_question.title).to eq 'New title'
            expect(user_owned_question.body).to eq 'New body'
          end

          it 'deletes file' do
            question_attachment = create(:answer_attachment, attachable: user_owned_question)
            expect {
              patch :update, xhr: true, params: {
                id: user_owned_question,
                question: {
                  title: 'Title',
                  body: 'Body',
                  attachments_attributes: {"0": {_destroy: 1, id: question_attachment}}
                }
              }
            }.to change(user_owned_question.attachments, :count).by(-1)
          end
        end

        context 'with invalid attributes' do
          it 'does not updates question' do
            patch :update, xhr: true, params: {id: user_owned_question, question: attributes_for(:invalid_question) }
            user_owned_question.reload
            expect(user_owned_question.title).not_to be_empty
            expect(response.status).to eq 422
          end
        end
      end

      context 'not owner of the question' do
        before { question }

        it 'returns 404 with no content' do
          patch :update, xhr: true, params: {id: question, question: attributes_for(:question) }
          expect(response.status).to eq 403
          expect(response.body).to be_empty
        end

        it 'does not updates question' do
          patch :update, xhr: true, params: {id: question, question: {title: 'New title'} }
          question.reload
          expect(question.title).not_to eq 'New title'
        end

        it 'does not deletes file' do
          question_attachment = create(:answer_attachment, attachable: question)
          expect {
            patch :update, xhr: true, params: {
              id: question,
              question: {
                title: 'Title',
                body: 'Body',
                attachments_attributes: {"0": {_destroy: 1, id: question_attachment}}
              }
            }
          }.not_to change(question.attachments, :count)
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

    describe 'POST #vote' do
      it 'assigns votable to @question' do
        vote_up
        expect(assigns(:votable)).to eq question
      end

      it 'responses with 200' do
        vote_up
        expect(response.status).to eq 200
      end

      context 'owner of the question' do
        it 'does not votes up\down question' do
          expect {
            post :vote_up, params: {id: user_owned_question, format: :json}
          }.not_to change(user_owned_question.votes, :count)
          expect {
            post :vote_down, params: {id: user_owned_question, format: :json}
          }.not_to change(user_owned_question.votes, :count)
        end
      end

      context 'not owner of the question' do
        it 'votes up' do
          expect {
            vote_up
          }.to change(question.votes, :count).by(1)
        end

        it 'votes down' do
          expect {
            vote_down
          }.to change(question.votes, :count).by(1)
        end

        it 'removes vote' do
          create(:answer_vote, user: user, votable: question)
          expect {
            post :cancel_vote, xhr: true, params: {id: question}
          }.to change(question.votes, :count).by(-1)
        end
      end
    end
  end
end
