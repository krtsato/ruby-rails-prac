# frozen_string_literal: true

require 'rails_helper'

describe Staff::Authenticator do
  describe '#authenticate' do
    example '正しいパスワードならば true を返す' do
      m = build(:staff_member)
      expect(described_class.new(m).authenticate('pw')).to be_truthy
    end

    example '誤ったパスワードならば false を返す' do
      m = build(:staff_member)
      expect(described_class.new(m).authenticate('xy')).to be_falsey
    end

    example 'パスワードが未設定ならば false を返す' do
      m = build(:staff_member, password: nil)
      expect(described_class.new(m).authenticate(nil)).to be_falsey
    end

    example '停止フラグが立っていれば false を返す' do
      m = build(:staff_member, suspended: true)
      expect(described_class.new(m).authenticate('pw')).to be_falsey
    end

    example '開始前ならば false を返す' do
      m = build(:staff_member, start_date: Time.zone.tomorrow)
      expect(described_class.new(m).authenticate('pw')).to be_falsey
    end

    example '終了後ならば false を返す' do
      m = build(:staff_member, end_date: Time.zone.today)
      expect(described_class.new(m).authenticate('pw')).to be_falsey
    end
  end
end
