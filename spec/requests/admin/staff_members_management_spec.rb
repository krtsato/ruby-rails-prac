# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::StaffMembers', type: :request do
  let(:administrator) {create(:administrator)}

  before do |example|
    unless example.metadata[:skip_before]
      post admin_session_url, params: {
        admin_login_form: {email: administrator.email, password: 'password'}
      }
    end
  end

  context 'when ログイン前', :skip_before do
    include_examples 'a protected admin controller', 'admin/staff_members'
  end

  describe '一覧' do
    example '成功' do
      get admin_staff_members_url
      expect(response.status).to eq(200)
    end
  end

  describe '新規登録' do
    let(:params_hash) {attributes_for(:staff_member)}

    example '職員一覧ページにリダイレクト' do
      post admin_staff_members_url, params: {staff_member: params_hash}
      expect(response).to redirect_to(admin_staff_members_url)
    end

    example '例外 ActionController::ParameterMissing が発生' do
      expect {post admin_staff_members_url}.to raise_error(ActionController::ParameterMissing)
    end
  end

  describe '更新' do
    let(:staff_member) {create(:staff_member)}
    let(:params_hash) {attributes_for(:staff_member)}

    example 'suspended フラグをセットする' do
      params_hash[:suspended] = true
      patch admin_staff_member_url(staff_member), params: {staff_member: params_hash}
      staff_member.reload # オブジェクトの各属性値を DB から再取得する
      expect(staff_member).to be_suspended
    end

    example 'hashed_password の値は書き換え不可' do
      params_hash.delete(:password)
      params_hash[:hashed_password] = 'x'
      expect {patch admin_staff_member_url(staff_member), params: {staff_member: params_hash}}.not_to \
        change(staff_member, :hashed_password.to_s)
    end
  end
end
