# frozen_string_literal: true

require 'rails_helper'

describe Admin::Authenticator do
  describe '#authenticate' do
    example '正しいパスワードならば true を返す' do
      a = build(:administrator)
      expect(described_class.new(a).authenticate('pw')).to be_truthy
    end

    example '誤ったパスワードならば false を返す' do
      a = build(:administrator)
      expect(described_class.new(a).authenticate('xy')).to be_falsey
    end

    example 'パスワードが未設定ならば false を返す' do
      a = build(:administrator, password: nil)
      expect(described_class.new(a).authenticate(nil)).to be_falsey
    end

    example '停止フラグが立っていても true を返す' do
      a = build(:administrator, suspended: true)
      expect(described_class.new(a).authenticate('pw')).to be_truthy
    end
  end
end
