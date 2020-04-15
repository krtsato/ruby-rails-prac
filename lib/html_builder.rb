# frozen_string_literal: true

module HtmlBuilder
  def markup(tag_name = nil, options = {})
    root = Nokogiri::HTML::DocumentFragment.parse('')

    Nokogiri::HTML::Builder.with(root) do |doc|
      if tag_name
        doc.method_missing(tag_name, options) do
          yield(doc)
        end
      else
        yield(doc)
      end
    end

    sanitize(root.to_html, tags: %w[a table th tr td])
  end
end