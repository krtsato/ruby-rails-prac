# frozen_string_literal: true

class StaffEvent < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :member, class_name: 'StaffMember', foreign_key: 'staff_member_id', inverse_of: :events
  alias_attribute :occurred_at, :created_at
end
