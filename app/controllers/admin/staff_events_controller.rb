# frozen_string_literal: true

module Admin
  class StaffEventsController < Base
    def index
      if params[:staff_member_id]
        @staff_member = StaffMember.find(params[:staff_member_id])
        @events = @staff_member.events.order(occurred_at: :desc)
      else
        @events = StaffEvent.order(occurred_at: :desc)
      end
      @events = @events.page(params[:page])
    end
  end
end
