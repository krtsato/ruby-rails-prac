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
      @form = LoginForm.new(params[:admin_login_form])
      if @form.email.present? then administrator = Administrator.find_by('LOWER(email) = ?', @form.email.downcase) end

      if Authenticator.new(administrator).authenticate(@form.password)
        if administrator.suspended?
          flash.now.alert = 'アカウントが停止されています'
          render action: 'new'
        else
          session[:administrator_id] = administrator.id
          flash.notice = 'ログインしました'
          redirect_to :admin_root
        end
      else
        flash.now.alert = 'メールアドレスまたはパスワードが正しくありません'
        render action: 'new'
      end
    end

    def destroy
      session.delete(:administrator_id)
      flash.notice = 'ログアウトしました'
      redirect_to :admin_root
    end
  end
end
