# frozen_string_literal: true

module Admin
  class StaffEventsController < Base
    def index
      if params[:staff_member_id]
        @staff_member = StaffMember.find(params[:staff_member_id])
        @events = @staff_member.events
      else
        @events = StaffEvent
      end
      @events = @events.order(occurred_at: :desc).includes(:member).page(params[:page])
    end
  end
end
