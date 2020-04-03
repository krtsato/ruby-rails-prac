# frozen_string_literal: true

module Staff
  class SessionsController < Base
    skip_before_action :authorize

    def new
      if current_staff_member
        redirect_to :staff_root
      else
        @form = LoginForm.new
        render action: 'new'
      end
    end

    def create
      @form = LoginForm.new(login_form_params)
      if @form.email.present? then staff_member = StaffMember.find_by('LOWER(email) = ?', @form.email.downcase) end

      if Authenticator.new(staff_member).authenticate(@form.password)
        if staff_member.suspended?
          back_to_login_form('アカウントが停止されています')
        else
          session[:staff_member_id] = staff_member.id
          session[:last_access_time] = Time.current
          flash.notice = 'ログインしました'
          redirect_to :staff_root
        end
      else
        back_to_login_form('メールアドレスまたはパスワードが正しくありません')
      end
    end

    def destroy
      session.delete(:staff_member_id)
      flash.notice = 'ログアウトしました'
      redirect_to :staff_root
    end

    private

    def login_form_params
      params.require(:staff_login_form).permit(:email, :password)
    end

    def back_to_login_form(alert_text)
      flash.now.alert = alert_text
      render action: 'new'
    end
  end
end
