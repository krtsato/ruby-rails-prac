# frozen_string_literal: true

class ErrorsController < ApplicationController
  helper_method :current_staff_member

  def not_found
    render 'errors/not_found', status: 404
  end

  def unprocessable_entity
    render 'errors/unprocessable_entity', status: 422
  end

  def internal_server_error
    render 'errors/internal_server_error', status: 500
  end

  private

  def current_staff_member
    return if session[:staff_member_id].blank?

    @current_staff_member ||= StaffMember.find_by(id: session[:staff_member_id])
  end
end
