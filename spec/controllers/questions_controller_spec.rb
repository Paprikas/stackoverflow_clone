require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  # DHH on testing templates and vars in controller
  # https://github.com/rails/rails/issues/18950

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
        }.to change(Question, :count).by(1)
      end

      it 'redirects to @question'
    end

    context 'with invalid attributes' do
      it "doesn't create new question in the database" do
        expect {
          post :create, params: {question: attributes_for(:invalid_question)}
        }.not_to change(Question, :count)
      end

      it 'renders new template'
    end
  end
end
