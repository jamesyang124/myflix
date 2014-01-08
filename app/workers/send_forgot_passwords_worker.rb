class SendForgotPasswordsWorker 
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id)
    user = User.find(user_id)
    AppMailers.send_forgot_password(user).deliver
  end
end