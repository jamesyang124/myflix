require 'spec_helper'

describe RelationshipsController do 
  describe 'GET #index' do 
    it_behaves_like 'require_sign_in' do 
      let(:action) { get :index }
    end

    it "render 'relationships/index'template" do 
      set_current_user
      get :index
      expect(response).to render_template 'relationships/index'
    end
  end

  describe 'POST #destroy' do 

  end
end