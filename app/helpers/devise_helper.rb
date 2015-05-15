module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = collect_messages
    sentence = collect_sentences

    html = <<-HTML
    <div id="error_explanation">
      <h2>#{sentence}</h2>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def collect_messages
    resource.errors
      .full_messages.map { |msg| content_tag(:li, msg) }
      .join
  end

  def collect_sentences
    I18n.t('errors.messages.not_saved',
           count: resource.errors.count,
           resource: resource.class.model_name.human.downcase)
  end
end
