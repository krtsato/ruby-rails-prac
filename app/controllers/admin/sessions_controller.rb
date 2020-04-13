# frozen_string_literal: true

module Admin
  class SessionsController < Base
    skip_before_action :authorize

    def new
      if current_administrator
        redirect_to :admin_root
      else
        @form = LoginForm.new
        render action: 'new'
      end
    end

    def create
      @form = LoginForm.new(login_form_params)
      if @form.email.present?
        administrator = Administrator.find_by(email: @form.email.downcase)
      end

      if Authenticator.new(administrator).authenticate(@form.password)
        divide_suspended_record(administrator)
      else
        back_to_login_form('メールアドレスまたはパスワードが正しくありません')
      end
    end

    def destroy
      session.delete(:administrator_id)
      go_to_admin_root('ログアウトしました')
    end

    private

    def login_form_params
      params.require(:admin_login_form).permit(:email, :password)
    end

    def go_to_admin_root(notice_text)
      flash.notice = notice_text
      redirect_to :admin_root
    end

    def back_to_login_form(alert_text)
      flash.now.alert = alert_text
      render action: 'new'
    end

    def divide_suspended_record(administrator)
      if administrator.suspended?
        back_to_login_form('アカウントが停止されています')
      else
        session[:administrator_id] = administrator.id
        session[:admin_last_access_time] = Time.current
        go_to_admin_root('ログインしました')
      end
    end
  end
end
