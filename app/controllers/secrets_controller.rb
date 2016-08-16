class SecretsController < ApplicationController
	before_action :require_login, only: [ :index, :create, :destroy ]

	def index
		data = Secret
			.joins('LEFT JOIN likes ON likes.secret_id = secrets.id')
			.joins('LEFT JOIN users ON likes.user_id = users.id')
			.select('secrets.id , secrets.content, secrets.user_id as owner, likes.id as like_id, likes.user_id as liked_user')
			.order('id DESC')
		
		result = []
		current_secret_id = 0
		data.each do |entry|
			if entry.id != current_secret_id
				current_secret_id = entry.id
				result << { id:entry.id, content:entry.content, owner:entry.owner, likes:[], liked_users:[] }
			end
			if entry.like_id
				result.last[:likes] << entry.like_id 
				result.last[:liked_users] << entry.liked_user
			end
		end

		@secrets = result
	end

	def create
		secret = Secret.new( secret_params )
		secret.user = User.find( session[:user_id])
		secret.save
		flash[:errors] = secret.errors.full_messages
		redirect_to "/users/#{session[:user_id]}"
	end

	def destroy
		secret = Secret.find( params[:id] )
		secret.destroy if secret.user == current_user
		redirect_to "/users/#{session[:user_id]}"
	end


	private 

	def secret_params
		params.require(:secret).permit(:user, :content)
	end
end

#result = Secret.joins("LEFT JOIN likes ON likes.secret_id = secrets.id LEFT JOIN users ON likes.user_id = users.id").select('secrets.id, COUNT(secrets.id), secrets.content').group('secrets.id')
#result = Secret.joins("LEFT JOIN likes ON likes.secret_id = secrets.id LEFT JOIN users ON likes.user_id = users.id").select('secrets.id, secrets.content, users.id')