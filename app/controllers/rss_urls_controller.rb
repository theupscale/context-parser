require 'rss'
class RssUrlsController < AdminController
	def new
		@rss = RssUrl.find(params[:id])
		render :index
	end

	def create
		@rss = RssUrl.new(params[:rss_url])
		@rss.save
		@source = @rss.source
		redirect_to :action=>:index,:source_id =>@source.id
	end
	
	def create_google
		@rss = RssUrl.new(params[:rss_url]) 
		@rss.url = "https://news.google.co.in/news/feeds?q=site:#{@rss.url}&num=100&safe=strict&hl=en&gl=in&authuser=0&biw=1366&bih=667&um=1&ie=UTF-8&output=rss"
		@rss.save
		@source = @rss.source
		redirect_to :action=>:index,:source_id =>@source.id
	end

	def edit
		@rss = RssUrl.find(params[:id])
		@source = @rss.source
		render :index

	end

	def update
		@rss = RssUrl.find(params[:id])
		@source = @rss.source
		redirect_to :action=>:index,:source_id =>@source.id
	end

	def delete
		@rss =RssUrl.find(params[:id])
		@rss.delete
		redirect_to(:action => :index, :notice => "Successfully updated feature.") and return
	end

	def index
		if (params[:source_id]!=nil)
			@source = Source.find(params[:source_id])
		else
			redirect_to :controller=>:sources,:action=>:index
		return
		end

		@rss = RssUrl.new(:source=>@source)
	end

	def test_rss
		@rss = RssUrl.find(params[:id])
		@valid = true
		@count = 0
		@error_count = 0
		url = @rss.url
		begin
			open(url) do |rss|
				feed = RSS::Parser.parse(rss)
				puts "Title: #{feed.channel.title}"
				puts "Feed counts #{feed.items.count}"
				feed.items.each do |item|
					@count += 1
					begin
						temp_link = URI(item.link)
					rescue Exception=>e
						@error_count+=1
						puts e.message
						puts e.backtrace
					end
				end
			end
		rescue Exception=>e
			@valid = false
			@exception = e.message
			@exception_details =  e.backtrace
		end
	end

end
