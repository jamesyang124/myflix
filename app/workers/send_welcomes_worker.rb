class SendWelcomesWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id)
    user = User.find(user_id)
    AppMailers.send_welcome_email(user).deliver
  end
end