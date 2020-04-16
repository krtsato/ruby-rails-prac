# frozen_string_literal: true

require 'html_builder'

module ApplicationHelper
  include HtmlBuilder

  def document_title(title)
    if title.present?
      "#{title} | Ruby-Rails-RSpec-Prac"
    else
      'Ruby-Rails-RSpec-Prac'
    end
  end
end
