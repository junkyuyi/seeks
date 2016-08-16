class UsersController < ApplicationController
	before_action :require_login, except: [:new, :create]
	before_action :require_correct_user, only: [:show, :edit, :update, :destroy]
	
	def index
	end

	def new
	end

	def create
		@user = User.create( user_params )
		flash[:errors] = @user.errors.full_messages unless @user.valid?
		if flash[:errors]
			redirect_to "/users/new"
		else
			session[:user_id] = @user.id
			redirect_to "/users/#{@user.id}"
		end
	end

	def show
		@user = User.find(params[:id])
		@secrets = @user.secrets
		@secrets_liked = @user.secrets_liked
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find( params[:id].to_s )
		@user.update ( user_params )
		flash[:errors] = @user.errors.full_messages unless @user.valid?
		if flash[:errors]
			redirect_to "/users/#{@user.id}/edit"
		else
			redirect_to "/users/#{@user.id}"
		end
	end

	def destroy
		User.find( params[:id].to_i ).destroy
		session[:user_id] = nil;
		redirect_to "/sessions/new"
	end

	private 

	def user_params
		params.require(:user).permit(:email, :name, :password, :password_confirmation)
	end
end
