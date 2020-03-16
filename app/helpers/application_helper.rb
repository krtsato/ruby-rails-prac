# frozen_string_literal: true

module ApplicationHelper
  def document_title
    if @title.present?
      "#{@title} - rrp"
    else
      "rrp"
    end
  end
end
