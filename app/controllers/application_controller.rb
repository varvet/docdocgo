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
  end
end
