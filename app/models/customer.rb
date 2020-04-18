# frozen_string_literal: true

class Customer < ApplicationRecord
  include EmailHolder
  include PasswordHolder
  include PersonalNameHolder

  has_one :home_address, dependent: :destroy, autosave: true
  has_one :work_address, dependent: :destroy, autosave: true

  validates :gender, inclusion: {in: %w[male female], allow_blank: true}
  validates :birthday, date: {
    after: Time.zone.local(1900, 1, 1).to_date,
    before: -> (_obj) {Time.zone.today},
    allow_blank: true
  }
end
