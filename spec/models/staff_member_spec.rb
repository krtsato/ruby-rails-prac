# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaffMember, type: :model do
  describe '#password=' do
    example '文字列を与えると hashed_password は長さ 60 の文字列になる' do
      member = StaffMember.new
      member.password = "password"
      expect(member.hashed_password).to be_kind_of(String)
      expect(member.hashed_password.size).to eq(60)
    end

    example 'nil を与えると hashed_password は nil になる' do
      member = StaffMember.new(hashed_password: 'string')
      member.password = nil
      expect(member.hashed_password).to eq(nil)
    end
  end
end
