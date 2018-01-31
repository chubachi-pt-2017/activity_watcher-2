module MarkdownHelper
  def markdown(text)
    unless @markdown
      renderer = CustomRender.new(filter_html: true, with_toc_data: true, hard_wrap: true, link_attributes: {target: '_blank'})
      options = {
            autolink: true,
            space_after_headers: true,
            no_intra_emphasis: true,
            fenced_code_blocks: true,
            prettify: true,
            tables: true,
            xhtml: true,
            lax_html_blocks: true,
            strikethrough: true
          }
      @markdown = Redcarpet::Markdown.new(renderer, options)
    end
    
    @markdown.render(text).html_safe
  end
  
  def create_toc(text)
    @toc = Redcarpet::Markdown.new Redcarpet::Render::HTML_TOC
    @toc.render(text).html_safe
  end
  
  class CustomRender < Redcarpet::Render::HTML
    def table(header, body)
      "<table class='table table-bordered' style='margin-bottom: 20px;'>" \
        "<thead style='background-color: #f5efef'>#{header}</thead>" \
        "<tbody>#{body}</tbody>" \
      "</table>"
    end
  end
end 