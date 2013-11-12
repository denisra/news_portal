class SessionsController < ApplicationController

    def create
          #user = User.from_omniauth(env["omniauth.auth"])
          #session[user_id] = user.id
          session[:oauth_token] = env['omniauth.auth'].credentials.token
          redirect_to root_url
    end
end