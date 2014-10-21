class VideosSweeper < ActionController::Caching::Sweeper
  observe Video

  def sweep(record)
    expire_record record
  end

  def after_create(record)
    expire_record record
  end


  def after_destroy(record)
    expire_record record
  end


  def after_update(record)
    expire_record record
  end

  private

  def expire_record(record)
    ActionController::Base.new.expire_fragment("videos_categories")
  end

  #alias_method :after_create, :sweep 
  #alias_method :after_destroy, :sweep
  #alias_method :after_update, :sweep 
end