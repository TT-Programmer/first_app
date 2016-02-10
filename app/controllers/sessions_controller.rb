class SessionsController < ApplicationController
	skip_before_filter :authorize

	def create

		if params[:session][:username].blank? || params[:session][:password].blank?
			redirect_to signin_path, alert: "ユーザ名またはパスワードを入力してください。"
			session[:login] = false
			return
		end

		@username = User.where("name = \'" + params[:session][:username] + "\'")

		if @username.nil? || @username.size != 1
			redirect_to signin_path, alert: "ユーザが存在しません。"
			session[:login] = false
			return
		end

		@password = User.where("name = \'" + params[:session][:username] + "\' and password = \'" + params[:session][:password] + "\'")
		puts @password.size

		if @password.size == 1
			session[:login] = true
			redirect_to "/top"
		else
			session[:login] = false
			redirect_to signin_path, alert: "パスワードが間違っています。"
		end
	end

	def new
		if session[:login] == true
			redirect_to "/top"
		end
	end

	def destroy
		session[:login] = false
		redirect_to signin_path, alert: "ログアウトしました。"
	end

end
