module ApplicationHelper
  def bootstrap_form_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(html: {class: "form-horizontal"})), &block)
  end

  def options_for_video_reviews(selected = nil)
    options_for_select((1..5).map{ |number| [pluralize(number,"Star"), number.to_s]}, selected)
  end

  def find_video_by_user_queue_items(video = nil)
    current_user.queue_items.find_by(video_id: video)
  end
end
