class UrlDumpsController < AdminController
	def dumps
		if (params[:id]!=nil)
			@date = Date.parse params[:id]
		else
			@date = Date.today
		end
		@page = params[:page] != nil ? params[:page].to_i : 0
	end

	def links
		if (params[:id]!=nil)
			@date = Date.parse params[:id]
		else
			@date = Date.today
		end
		@page = params[:page] != nil ? params[:page].to_i : 0
	end

	def delete_link
		date = l.published_on.strftime("%Y-%m-%d")
		l = UrlLink.find(params[:id])
		l.destroy
		redirect_to :action=>:links,:id=>date
	end

	def reprocess
		u = UrlLinkDump.find(params[:id])
		u.process
		redirect_to :action=>:today
	end
end
