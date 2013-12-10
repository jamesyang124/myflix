require 'spec_helper'

describe CategoriesController do 
  before :each do
    set_current_user 
    @category = create(:category)
  end

  context 'have signed in' do 
    it 'GET categories#show' do 
      get :show, id: @category
      expect(assigns(:category)).to eq(@category) 
    end
  end

  context 'have not signed in' do 
    context 'GET categories#show' do 
      it_behaves_like 'require_sign_in' do 
        let(:action) { get :show, id: @category }
      end
    end
  end
end