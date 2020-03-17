# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout :set_layout

  private

  def set_layout
    if params[:controller] =~ %r{\A(staff|admin|customer)/}
      Regexp.last_match[1]
    else
      'customer'
    end
  end

  def rescue500(e)
    render 'errors/internal_server_error', status: 500
  end
end
