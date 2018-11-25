require 'sinatra/base'
require 'sinatra/flash'
require 'uri'
require_relative 'lib/user.rb'
require_relative 'lib/message.rb'
require_relative './database_connection_setup.rb'
require 'date'

class Chitter < Sinatra::Base
	enable :sessions
	register Sinatra::Flash

	get '/' do
		@messages = Message.all
		@user = User.find(id: session[:user_id])
		erb(:'index')
	end

	get '/users/new' do
		erb(:'users/new')
	end

	get '/sessions/new' do
		erb(:'sessions/new')
	end

	get '/chitter/create' do
		@user = User.find(id: session[:user_id])
		erb(:'chitter/new')
	end

	# INICIO DE CRUD
	post '/chitter' do
		time = Time.now
		message = Message.create(text: params['text'], m_date: time.strftime("%Y-%m-%d"), user_id: params['user_id'])
		redirect('/')
	end

	post '/users' do
		user = User.create(name: params['name'], u_name: params['u_name'], email: params['email'], password: params['password'])
		session[:user_id] = user.id
		redirect('/')
	end

	post '/sessions' do
		user = User.authenticate(email: params['email'], password: params['password'])
		if user
			session[:user_id] = user.id
			redirect('/')
		else
			flash[:notice] = 'Please Check your email or password'
			redirect('/sessions/new')
		end
	end

	post '/sessions/destroy' do
		session.clear
    	flash[:notice] = 'You have signed out.'
    	redirect('/')
	end

run! if app_file == $0
end