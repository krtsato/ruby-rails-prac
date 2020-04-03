# frozen_string_literal: true

module Admin
  class Base < ApplicationController
    before_action :authorize

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
  end
end
