# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaffMember, type: :model do
  describe '#password=' do
    example '文字列を与えると hashed_password は文字列になる' do
      member = described_class.new
      member.password = 'password'
      expect(member.hashed_password).to be_kind_of(String)
    end

    example '文字列を与えると hashed_password は長さ 60 になる' do
      member = described_class.new
      member.password = 'password'
      expect(member.hashed_password.size).to eq(60)
    end

    example 'nil を与えると hashed_password は nil になる' do
      member = described_class.new(hashed_password: 'string')
      member.password = nil
      expect(member.hashed_password).to eq(nil)
    end
  end
end
