shared_examples "require_sign_in" do
  it 'redirect to front page' do
    clear_current_user
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples 'tokenable' do 
  it 'generate a random token when the user is created' do 
    expect(object.token).to be_present
  end
end