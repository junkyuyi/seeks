class LikesController < ApplicationController
	before_action :require_login, only: [ :create, :destroy ]

	def create
		secret = Secret.find( params[:secret_id] )
		secret.likes.create(user: current_user)
		redirect_to "/secrets"
	end

	def destroy
		like = Like.find(params[:id])
		like.destroy if like.user == current_user
		redirect_to "/secrets"
	end
end
