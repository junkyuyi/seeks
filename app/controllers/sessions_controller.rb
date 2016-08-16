class SessionsController < ApplicationController
	def new
	end

	def create
		@user = User.find_by_email( params[:email] )
		if @user.nil? or  !@user.authenticate params[:password]
			flash[:errors] = ["Invalid"]
			redirect_to "/sessions/new"
		else
			session[:user_id] = @user.id
			redirect_to "/users/#{@user.id}"
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to "/sessions/new"
	end


	private 

	def user_params
		params.require(:user).permit(:email, :password)
	end
end

