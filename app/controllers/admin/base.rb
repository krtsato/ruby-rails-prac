# frozen_string_literal: true

module Admin
  class Base < ApplicationController
    private

    def current_administrator
      return if session[:administrator_id].blank?

      @current_administrator ||= Administrator.find_by(id: session[:administrator_id])
    end

    helper_method :current_administrator
  end
end
