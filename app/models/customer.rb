# frozen_string_literal: true

class Customer < ApplicationRecord
  include EmailHolder
  include PersonalNameHolder

  has_one :home_address, dependent: :destroy, autosave: true
  has_one :work_address, dependent: :destroy, autosave: true

  validates :gender, inclusion: {in: %w[male female], allow_blank: true}
  validates :birthday, date: {
    after: Time.zone.local(1900, 1, 1).to_date,
    before: -> (_obj) {Time.zone.today},
    allow_blank: true
  }

  def password=(raw_password)
    if raw_password.is_a?(String)
      self.hashed_password = BCrypt::Password.create(raw_password)
    elsif raw_password.nil?
      self.hashed_password = nil
    end
  end
end
