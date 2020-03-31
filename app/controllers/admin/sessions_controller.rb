# frozen_string_literal: true

module Admin
  class SessionsController < Base
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
      if @form.email.present? then administrator = Administrator.find_by('LOWER(email) = ?', @form.email.downcase) end

      if Authenticator.new(administrator).authenticate(@form.password)
        if administrator.suspended?
          back_to_login_form('アカウントが停止されています')
        else
          session[:administrator_id] = administrator.id
          flash.notice = 'ログインしました'
          redirect_to :admin_root
        end
      else
        back_to_login_form('メールアドレスまたはパスワードが正しくありません')
      end
    end

    def destroy
      session.delete(:administrator_id)
      flash.notice = 'ログアウトしました'
      redirect_to :admin_root
    end

    private

    def login_form_params
      params.require(:admin_login_form).permit(:email, :password)
    end

    def back_to_login_form(alert_text)
      flash.now.alert = alert_text
      render action: 'new'
    end
  end
end
