class Project
  attr_reader :organization, :project, :version

  def initialize(organization, project, version)
    @organization = organization
    @project = project
    @version = version
  end

  def as_html
    markdown.render(body).html_safe
  end

  def versions
    ["docdocgo", "v1.0.0", "v0.12.4", "v0.9.0", "v0.0.2"]
  end

  def url_for_version(version)
    [organization, project, version].join("/")
  end

  def headers
    Nokogiri::HTML(as_html).css("h2, h3, h4, h5").reduce([]) do |arr, node|
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

  private

  def html_renderer
    HTMLwithRouge.new(with_toc_data: true)
  end

  def markdown
    Redcarpet::Markdown.new(html_renderer, fenced_code_blocks: true)
  end

  def body
    client.get("#{organization}/#{project}/#{version}/README.md?foo").body
  end

  def client
    @client ||= Hurley::Client.new("https://raw.githubusercontent.com")
  end
end
