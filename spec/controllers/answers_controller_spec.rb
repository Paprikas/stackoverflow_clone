require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:user_owned_answer) { create(:answer, question: question, user: user) }
  let(:answer) { create(:answer, question: question) }
  subject(:post_valid_answer) { post :create, xhr: true, params: {question_id: question, answer: attributes_for(:answer)} }
  subject(:delete_answer) { delete :destroy, xhr: true, params: {question_id: question, id: answer} }
  subject(:delete_own_answer) { delete :destroy, xhr: true, params: {question_id: question, id: user_owned_answer} }
  subject(:accept_answer) { post :accept, params: {question_id: question, id: answer} }

  describe 'guest user' do
    describe 'PATCH #update' do
      it 'responses with 401' do
        patch :update, xhr: true, params: {question_id: question, id: answer.id}
        expect(response.status).to eq 401
      end
    end

    describe 'POST #create' do
      it 'redirects to user login form' do
        post_valid_answer
        expect(response.status).to eq 401
      end
    end

    describe 'POST #accept' do
      it 'redirects to user login form' do
        accept_answer
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe 'DELETE #destroy' do
      it 'responses with 401' do
        delete_answer
        expect(response.status).to eq 401
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

        it 'renders create.js' do
          post_valid_answer
          expect(response.status).to eq 200
          expect(response).to render_template 'create'
        end

        it 'checks that answer belongs to user' do
          expect {
            post_valid_answer
          }.to change(user.answers, :count).by(1)
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

    describe 'PATCH #update' do
      context 'owner of the question' do
        let(:answer_attachment) { create(:answer_attachment, attachable: user_owned_answer) }
        before { user_owned_answer }

        context 'with valid attributes' do
          it 'renders update template' do
            patch :update, xhr: true, params: {question_id: question, id: user_owned_answer, answer: attributes_for(:answer)}
            expect(response).to render_template :update
          end

          it 'updates answer' do
            patch :update, xhr: true, params: {question_id: question, id: user_owned_answer, answer: {body: 'New body'}}
            user_owned_answer.reload
            expect(user_owned_answer.body).to eq 'New body'
          end

          it 'deletes file' do
            expect {
              patch :update, xhr: true, params: {
                question_id: user_owned_answer.question,
                id: user_owned_answer,
                answer: {
                  body: 'Body',
                  attachments_attributes: {"0": {_destroy: 1, id: answer_attachment}}
                }
              }
            }.to change(user_owned_answer.attachments, :count).by(-1)
          end

          it do
            params = {
              answer: {
                body: 'Body',
                attachments_attributes: {
                  '0': {
                    _destroy: 1,
                    id: answer_attachment2
                  }
                }
              },
              question_id: user_owned_answer.question,
              id: user_owned_answer
            }
            should permit(:body, attachments_attributes: [:id, :file, :_destroy])
              .for(:update, params: {params: params})
              .on(:answer)
          end
        end

        context 'with invalid attributes' do
          it 'does not updates answer' do
            patch :update, xhr: true, params: {question_id: question, id: user_owned_answer, answer: attributes_for(:invalid_answer) }
            user_owned_answer.reload
            expect(user_owned_answer.body).not_to be_empty
            expect(response.status).to eq(422)
          end
        end
      end

      context 'not owner of the question' do
        before { answer }

        it 'returns 404 with no content' do
          patch :update, xhr: true, params: {question_id: question, id: answer, answer: attributes_for(:answer) }
          expect(response.status).to eq(401)
          expect(response.body).to be_empty
        end

        it 'does not updates question' do
          patch :update, xhr: true, params: {question_id: question, id: answer, answer: {body: 'New title'} }
          answer.reload
          expect(answer.body).not_to eq 'New title'
        end

        it 'does not deletes file' do
          answer_attachment = create(:answer_attachment, attachable: answer)
          expect {
            patch :update, xhr: true, params: {
              question_id: answer.question,
              id: answer,
              answer: {
                body: 'Body',
                attachments_attributes: {"0": {_destroy: 1, id: answer_attachment}}
              }
            }
          }.not_to change(answer.attachments, :count)
        end
      end
    end

    describe 'POST #accept' do
      context 'owner of the answer' do
        it 'assigns answer to @answer' do
          accept_answer
          expect(assigns(:answer)).to eq answer
        end

        it 'accepts the answer' do
          expect {
            accept_answer
          }.to change { answer.reload.accepted }.from(false).to(true)
        end

        it 'accepts another answer' do
          accepted_answer = create(:answer, question: question, accepted: true)
          expect {
            accept_answer
          }.to change { accepted_answer.reload.accepted }.from(true).to(false)
        end

        it 'redirects to @question' do
          accept_answer
          expect(response).to redirect_to question
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'owner of the answer' do
        it 'deletes answer from database' do
          user_owned_answer
          expect {
            delete_own_answer
          }.to change(question.answers, :count).by(-1)
        end

        it 'renders destroy template' do
          delete_own_answer
          expect(response).to render_template :destroy
        end
      end

      context 'not owner of the answer' do
        it 'does not deletes answer from database' do
          answer
          expect {
            delete_answer
          }.not_to change(question.answers, :count)
        end

        it 'responses with 401' do
          delete_answer
          expect(response.status).to eq 401
        end
      end
    end
  end
end
