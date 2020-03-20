# frozen_string_literal: true

module ApplicationHelper
  def document_title(title)
    if title.present?
      "#{title} | Ruby-Rails-RSpec-Prac"
    else
      'Ruby-Rails-RSpec-Prac'
    end
  end
end
