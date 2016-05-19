require 'rails_helper'

shared_examples 'unauthorized access' do |path|
  it 'returns 401 status without access_token' do
    get path, params: {format: :json}
    expect(response.status).to eq 401
  end

  it 'returns 401 status when access_token invalid' do
    get path, params: {access_token: '1234', format: :json}
    expect(response.status).to eq 401
  end
end

shared_examples 'unauthorized post access' do |path|
  it 'returns 401 status without access_token' do
    post path, params: {format: :json}
    expect(response.status).to eq 401
  end

  it 'returns 401 status when access_token invalid' do
    post path, params: {access_token: '1234', format: :json}
    expect(response.status).to eq 401
  end
end

describe 'Questions API' do
  let(:access_token) { create(:access_token) }
  let(:question1) { create(:question) }
  let(:question2) { create(:question) }

  context 'authorized' do
    describe 'GET /index' do
      let!(:questions) { create_pair(:question) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before do
        get "/api/v1/questions", params: {access_token: access_token.token, format: :json}
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      context 'answers' do
        it 'includes answers' do
          expect(response.body).to have_json_size(1).at_path('0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end

    describe 'GET #show' do
      let!(:comment) { create(:comment, commentable: question1) }
      let!(:attachment) { create(:attachment, attachable: question1) }

      before do
        get "/api/v1/questions/#{question1.id}", params: {access_token: access_token.token, format: :json}
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question1.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      context 'comments' do
        it 'includes comments' do
          expect(response.body).to have_json_size(1).at_path('comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'includes attachments' do
          expect(response.body).to have_json_size(1).at_path('attachments')
        end

        it "contains filename" do
          expect(response.body).to be_json_eql(attachment.file.filename.to_json).at_path("attachments/0/filename")
        end

        it "contains url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/url")
        end
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        let(:post_question) do
          post "/api/v1/questions", params: {access_token: access_token.token, format: :json, question: attributes_for(:question)}
        end

        it 'returns 201 status' do
          post_question
          expect(response.status).to eq 201
        end

        it 'creates question' do
          expect { post_question }.to change(Question, :count).by(1)
        end
      end

      context 'with invalid params' do
        let(:post_invalid_question) do
          post "/api/v1/questions", params: {access_token: access_token.token, format: :json, question: attributes_for(:invalid_question)}
        end

        it 'returns 422 status' do
          post_invalid_question
          expect(response.status).to eq 422
        end

        it 'does not creates question' do
          expect { post_invalid_question }.not_to change(Question, :count)
        end
      end
    end
  end

  context 'not authorized' do
    describe 'GET #index' do
      it_behaves_like 'unauthorized access', '/api/v1/questions'
    end

    describe 'GET #show' do
      it_behaves_like 'unauthorized access', "/api/v1/questions/1"
    end

    describe 'POST #create' do
      it_behaves_like 'unauthorized post access', "/api/v1/questions"
    end
  end
end
