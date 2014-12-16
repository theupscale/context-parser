class AdminController < ApplicationController
	layout 'admin'
	
	before_filter :check_logged_in, :except=>[:admin_index,:login]
	
	def admin_index
		render "index"
	end
	
	def logout
		session[:logged_in] = false
		redirect_to :action=>:index
	end
	
	def login
		@username = params[:username]
		@password = params[:password]
		if (@username == "" || @password == "")
			flash[:message] = "Please enter your login creds"
		else
			if (@username=="admin" && @password=="admin")
				session[:logged_in] = true
				redirect_to :controller=>:home, :action=>:report
			else
				flash[:message] = "Incorrect Details. Please check your login credentials"
			end
		end
		
		if (flash[:message]!=nil)
			redirect_to :action=>:index
			return
		end
	end
	
	def check_logged_in
		if (!session[:logged_in])
			flash[:message] = "You must log in to continue"
			redirect_to :controller=>:admin,:action=>:admin_index
			return false
		end
	end
end