class AppMailersWorker 
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(obj_id, *obj_params)
    obj_class = Object.const_get(obj_params.fetch(0))
    obj = obj_class.find(obj_id)
    AppMailers.send(obj_params.fetch(1), obj).deliver
  end
end