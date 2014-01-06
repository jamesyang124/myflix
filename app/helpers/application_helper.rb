module ApplicationHelper
  def simple_customed_form_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(html: {class: "form-horizontal"})), &block)
  end

  def options_for_video_reviews(selected = nil)
    options_for_select((1..5).map{ |number| [pluralize(number,"Star"), number.to_s]}, selected)
  end
end
