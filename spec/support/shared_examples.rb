shared_examples "require_sign_in" do
  it 'redirect to front page' do
    clear_current_user
    action
    expect(response).to redirect_to sign_in_path
  end
end
