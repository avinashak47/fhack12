class LoginController < ApplicationController

def fb_login
	@oauth = Koala::Facebook::OAuth.new(FB[:id], FB[:secret], 'http://gentle-fire-7931.heroku.com/FB/FBCallback')
	render :text=>@oauth.url_for_oauth_code(:permissions=>"user_actions.music,user_likes,friends_likes,user_actions.music")
end

def fb_callback
	 if(params[:code].nil?)
		render :json=>{"Error":"Put more shiz in from the error foo!"}
	 else
	 	@@oauth_token = @oauth.get_access_token(params[:code])
		DataController::build_song_index(@@oauth_token)	
	 end
end

end
