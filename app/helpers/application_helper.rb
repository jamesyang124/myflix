module ApplicationHelper
  def bootstrap_form_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(html: {class: "form-horizontal"})), &block)
  end
end
