require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:user) { create(:user) }

  let(:comment_question) do
    post :create, xhr: true, params: {commentable: 'question', commentable_id: question, comment: attributes_for(:comment)}
  end

  let(:invalid_comment_question) do
    post :create, xhr: true, params: {commentable: 'question', commentable_id: question, comment: attributes_for(:comment, :invalid)}
  end

  context 'as user' do
    before { sign_in user }

    describe "POST #create" do
      it "returns http success" do
        comment_question
        expect(response).to have_http_status :success
      end

      it "assigns comment to @comment" do
        comment_question
        expect(assigns(:comment)).to eq question.comments.first
      end

      it "assigns commentable to @commentable" do
        comment_question
        expect(assigns(:commentable)).to eq question
      end

      it 'creates comment' do
        expect { comment_question }.to change(question.comments, :count).by(1)
      end

      it "doesn't creates invalid comment" do
        expect { invalid_comment_question }.not_to change(question.comments, :count)
      end

      it "returns unprocessable_entity if commentable not set" do
        post :create, xhr: true, params: {commentable: '', commentable_id: '', comment: attributes_for(:comment)}
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  context 'as guest' do
    describe "POST #create" do
      it "returns http unauthorized" do
        post :create, xhr: true, params: {commentable: 'question', commentable_id: question, comment: attributes_for(:comment)}
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
