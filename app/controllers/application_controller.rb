class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def project
    client   = Hurley::Client.new("https://raw.githubusercontent.com")
    response = client.get("#{params[:organization]}/#{params[:project]}/docdocgo/README.md?foo")
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer, fenced_code_blocks: true)
    @content = markdown.render(response.body)
    html = Nokogiri::HTML(@content)
    @headers = html.css("h2, h3, h4, h5").reduce([]) do |arr, node|
      if node.name == "h2"
        arr << node.text
      else
        if arr.last.is_a?(Array)
          arr.last << node.text
        else
          arr << [node.text]
        end
      end
      arr
    end
  end
end
