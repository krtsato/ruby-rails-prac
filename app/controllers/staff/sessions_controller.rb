# frozen_string_literal: true

module Staff
  class SessionsController < Base
    def new
      if current_staff_member
        redirect_to :staff_root
      else
        @form = LoginForm.new
        render action: 'new'
      end
    end

    def create
      @form = LoginForm.new(params[:staff_login_form])
      if @form.email.present? then staff_member = StaffMember.find_by('LOWER(email) = ?', @form.email.downcase) end

      if Authenticator.new(staff_member).authenticate(@form.password)
        if staff_member.suspended?
          flash.now.alert = 'アカウントが停止されています'
          render action: 'new'
        else
          session[:staff_member_id] = staff_member.id
          flash.notice = 'ログインしました'
          redirect_to :staff_root
        end
      else
        flash.now.alert = 'メールアドレスまたはパスワードが正しくありません'
        render action: 'new'
      end
    end

    def destroy
      session.delete(:staff_member_id)
      flash.notice = 'ログアウトしました'
      redirect_to :staff_root
    end
  end
end
