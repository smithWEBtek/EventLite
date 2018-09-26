class SessionsController < ApplicationController

    def new
        @user = User.new
        @users = User.all
    end

    def create
        if auth_hash = request.env["omniauth.auth"] 
            @user = User.find_or_create_by_omniauth(auth_hash)
                session[:user_id] = @user.id
                redirect_to user_path(@user)
        else
            @user = User.find_by(email: params[:user][:email])
            
            if @user && @user.authenticate(params[:user][:password])
                session[:user_id] = @user.id
                redirect_to user_path(@user)
                flash[:success] = "Successfully logged in!" #not working                   
            else
                redirect_to login_path
                flash[:error] = "Couldn't find username and password"
            end

        end
    end

    def destroy
        session.destroy
        redirect_to root_url
    end

    # private
    # def auth_hash
    #     request.env["omniauth.auth"]
    # end
end
