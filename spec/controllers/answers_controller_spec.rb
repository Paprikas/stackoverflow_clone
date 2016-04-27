require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

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
        }.to change(Answer, :count).by(1)
      end

      it 'redirects to @answer'
    end

    context 'with invalid attributes' do
      it "doesn't create new answer in the database" do
        expect {
          post :create, params: {question_id: question, answer: attributes_for(:invalid_answer)}
        }.not_to change(Answer, :count)
      end

      it 'renders new template'
    end
  end
end
