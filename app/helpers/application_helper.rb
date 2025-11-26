module ApplicationHelper
  def render_markdown(text)
    Markdown.new(text).to_html
  end
end
