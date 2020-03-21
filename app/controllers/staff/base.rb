# frozen_string_literal: true

module Staff
  class Base < ApplicationController
    private

    def current_staff_member
      return if session[:staff_member_id].blank?

      @current_staff_member ||= StaffMember.find_by(id: session[:staff_member_id])
    end

    helper_method :current_staff_member
  end
end
