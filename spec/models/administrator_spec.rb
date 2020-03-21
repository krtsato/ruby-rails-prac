require 'rails_helper'

RSpec.describe Administrator, type: :model do
  describe '#password=' do
    example '文字列を与えると hashed_password は文字列になる' do
      admin = described_class.new
      admin.password = 'password'
      expect(admin.hashed_password).to be_kind_of(String)
    end

    example '文字列を与えると hashed_password は長さ 60 になる' do
      admin = described_class.new
      admin.password = 'password'
      expect(admin.hashed_password.size).to eq(60)
    end

    example 'nil を与えると hashed_password は nil になる' do
      admin = described_class.new(hashed_password: 'string')
      admin.password = nil
      expect(admin.hashed_password).to eq(nil)
    end
  end
end
