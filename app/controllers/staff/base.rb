# frozen_string_literal: true

module Staff
  class Base < ErrorsController
    before_action :authorize
    before_action :check_account
    before_action :check_timeout

    private

    def authorize
      return if current_staff_member.present?

      flash.alert = '職員としてログインして下さい'
      redirect_to :staff_login
    end

    def check_account
      return if current_staff_member.blank? || current_staff_member.active?

      session.delete(:staff_member_id)
      flash.alert = 'アカウントが無効になりました'
      redirect_to :staff_root
    end

    TIMEOUT = 60.minutes

    def check_timeout
      return if current_staff_member.blank?

      if session[:staff_last_access_time] >= TIMEOUT.ago
        session[:staff_last_access_time] = Time.current
      else
        session.delete(:staff_member_id)
        flash.alert = 'セッションがタイムアウトしました'
        redirect_to :staff_login
      end
    end
  end
end
