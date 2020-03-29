# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ルーティング', type: :routing do
  config = Rails.application.config.rrrp

  example '職員トップページ' do
    url = "http://#{config[:staff][:host]}/#{config[:staff][:path]}"
    expect(get: url).to route_to(
      host: config[:staff][:host],
      controller: 'staff/top',
      action: 'index'
    )
  end

  example '管理者ログインフォーム' do
    url = "http://#{config[:admin][:host]}/#{config[:admin][:path]}/login"
    expect(get: url).to route_to(
      host: config[:admin][:host],
      controller: 'admin/sessions',
      action: 'new'
    )
  end

  example "顧客トップページ" do
    url = "http://#{config[:customer][:host]}/#{config[:customer][:path]}"
    expect(get: url).to route_to(
      host: config[:customer][:host],
      controller: "customer/top",
      action: "index"
    )
  end

  example 'ホスト名が対象外ならば routable でない' do
    expect(get: 'http://xyz.example.com').not_to be_routable
  end

  example '存在しないパスならば routable でない' do
    expect(get: "http://#{config[:staff][:host]}/xyz").not_to be_routable
  end
end
