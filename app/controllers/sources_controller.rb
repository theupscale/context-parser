# encoding: utf-8
load 'parser/url_fetch.rb'
class SourcesController < AdminController
	def index
		@source = Source.new
	end

	def new
		@source = Source.new
	end
	
	def disable
		@source = Source.find(params[:id])
		@source.enabled = !@source.enabled
		@source.save
		redirect_to :action=>:index
	end

	def create
		@source = Source.new(params[:source])
		if (@source.save)
			redirect_to :action=>:index
		else
			render "index"
		end
	end

	def edit
		@source = Source.find(params[:id])
		render "new"
	end

	def update
		@source = Source.find(params[:id])
		if @source.update_attributes(params[:source])
			redirect_to :action=>:index
		else
			render "index"
		end
	end

	def test_urls
		@url = params[:test_url]

		if (!params[:date].blank?)
			@date = DateTime.strptime(params[:date], "%d/%m/%Y")
		else
			@date = nil
		end

		if (@url!=nil)
			@dump = UrlLinkDump.find_by_url(@url)
			puts "Found #{@dump}"
			
			@found = (@dump!=nil)
			@last_status = (@dump.processed) unless @dump==nil
			@last_link = UrlLink.find_by_url(@dump.url) unless @dump == nil
			
			if (@dump==nil)
				@dump = UrlLinkDump.new(:url=>@url,:etag=>Digest::MD5.hexdigest(@url),:published_on=>@date)
			else
				if @dump.published_on == nil
					@dump.published_on = @date
				end
			end
			
			@dump.save
		end
	end

	def delete
		@source = Source.find(params[:id])
		@source.destroy
		redirect_to :action=>:index
	end
end
