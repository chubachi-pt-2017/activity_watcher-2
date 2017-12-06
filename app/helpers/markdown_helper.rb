module MarkdownHelper
  def markdown(text)
    unless @markdown
      renderer = Redcarpet::Render::HTML.new(filter_html: true)
      options = {
            autolink: true,
            space_after_headers: true,
            no_intra_emphasis: true,
            fenced_code_blocks: true,
            prettify: true,
            tables: true,
            hard_wrap: true,
            xhtml: true,
            lax_html_blocks: true,
            strikethrough: true
          }
      @markdown = Redcarpet::Markdown.new(renderer, options)
    end
    
    # スペース未挿入でも<br>タグに変換されるようにspace×2を挿入
    text = text.gsub(/\r\n/, "  \r\n")
    
    @markdown.render(text).html_safe
  end
end