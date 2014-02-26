module PrettyHtml

  # Methods for matching HTML output with blocks of HTML in spec files.

  def pretty_html(html)
    Nokogiri::XML(html, &:noblanks).to_xhtml
  end

  # Outdent all lines by the amount of whitespace before the first line
  def outdent(text)
    lines = text.split("\n")
    indented_with = /^ +/.match(lines.first)[0]
    lines.map { |line| line.gsub(/^#{indented_with}/, '') }.join("\n") + "\n"
  end
end

RSpec.configure do |config|
  config.include PrettyHtml
end
