require 'bundler'
Bundler.require
require_relative 'credentals'
require 'rack/flash'

enable :sessions
use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], { :hd => ['fout.jp', 'japantaxi.co.jp']}
end

configure do
  use Rack::Flash
end

helpers do
  def login?
    if session[:user].nil?
      return false
    else
      return true
    end
  end

  def user_name
    return session[:user]['name']
  end

  def user_email
    return session[:user]['email']
  end

  def user_domain
    user_email.split('@').last
  end

  def user_image
    return session[:user]['image']
  end
end

get '/' do
  erb :index
end

get '/logout' do
  session[:user] = nil
  redirect '/'
end

get '/auth/failure' do
  content_type 'text/plain'
  begin
    flash[:message] = request['message']     
    redirect '/'
  rescue StandardError
    'No Data'
  end
end

get '/auth/google_oauth2/callback' do
  begin
    session[:user] = request.env['omniauth.auth'].info.to_hash
    redirect '/'
  rescue StandardError
    'Login failure'
  end
end


