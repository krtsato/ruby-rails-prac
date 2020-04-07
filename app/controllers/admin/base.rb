# frozen_string_literal: true

module Admin
  class Base < ApplicationController
    before_action :authorize
    before_action :check_account
    before_action :check_timeout

    private

    def current_administrator
      return if session[:administrator_id].blank?

      @current_administrator ||= Administrator.find_by(id: session[:administrator_id])
    end

    helper_method :current_administrator

    def authorize
      return if current_administrator.present?

      flash.alert = '管理者としてログインして下さい'
      redirect_to :admin_login
    end

    def check_account
      return if current_administrator.blank? || !current_administrator.suspended?

      session.delete(:administrator_id)
      flash.alert = 'アカウントが無効になりました'
      redirect_to :admin_root
    end

    TIMEOUT = 60.minutes

    def check_timeout
      return if current_administrator.blank?

      if session[:admin_last_access_time] >= TIMEOUT.ago
        session[:admin_last_access_time] = Time.current
      else
        session.delete(:administrator_id)
        flash.alert = 'セッションがタイムアウトしました'
        redirect_to :admin_login
      end
    end
  end
end
