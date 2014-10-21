module ApplicationHelper
  def simple_customed_form_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(html: {class: "form-horizontal", })), &block)
  end

  def simple_payment_form(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(html: {class: "form-horizontal", id: "payment-form"})), &block)   
  end

  def options_for_video_reviews(selected = nil)
    options = (1..5).map{ |number| [pluralize(number,"Star"), number.to_s]}
    options_for_select(options, selected)
  end
end
