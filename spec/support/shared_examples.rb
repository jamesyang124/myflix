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

shared_examples "require_admin" do 
  it 'redirect to home path' do
    set_current_user 
    action
    expect(response).to redirect_to home_path
  end
end