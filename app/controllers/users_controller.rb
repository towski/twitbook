class UsersController < ApplicationController
	def show
    @user = TwitterUser.find_by_screen_name(params[:id])
	  @statuses = @user.friends_statuses
	end
end
