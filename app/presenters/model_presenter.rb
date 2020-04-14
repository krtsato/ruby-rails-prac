# frozen_string_literal: true

class ModelPresenter
  include HtmlBuilder
  attr_reader :object, :view_context

  delegate :sanitize, to: :view_context

  def initialize(object, view_context)
    @object = object
    @view_context = view_context
  end
end
