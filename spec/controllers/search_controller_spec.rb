require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "GET #search" do
    it "returns http success and renders search template" do
      get :search
      expect(response).to have_http_status :success
      expect(response).to render_template :search
    end

    it "assigns @results with [] if invalid search_type" do
      get :search, params: {search_type: ''}
      expect(assigns(:results)).to eq []
    end
  end
end
