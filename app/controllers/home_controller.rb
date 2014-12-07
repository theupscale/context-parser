class HomeController < ApplicationController
	layout 'home'
	def index
		@selected_context = params[:context_id]
		@selected_country = params[:country]
		@selected_source = params[:source_id]

		@top_news = UrlLink.with_relevant_context(@selected_context,@selected_country,@selected_source,7)

		@contexts = []
		@top_news.each {|news| news.keyword_contexts.each {|c| @contexts << c unless (!c.is_relevant || @contexts.include?(c))}}

		@sources = []
		@top_news.each {|news| @sources << news.source unless @sources.include? news.source}

		@countries = []
		@top_news.each {|news| @countries << news.source.country unless @countries.include? news.source.country}
	end

	def archived
		begin
			@date = Date.new params["article"]["created_on(1i)"].to_i, params["article"]["created_on(2i)"].to_i, params["article"]["created_on(3i)"].to_i
		rescue Exception=>ex
			redirect_to :action=>:index
			return
		end
		@top_news = UrlLink.with_relevant_context_on_date(@selected_context,@selected_country,@selected_source,@date)

		@contexts = []
		@top_news.each {|news| news.keyword_contexts.each {|c| @contexts << c unless (!c.is_relevant || @contexts.include?(c))}}

		@sources = []
		@top_news.each {|news| @sources << news.source unless @sources.include? news.source}

		@countries = []
		@top_news.each {|news| @countries << news.source.country unless @countries.include? news.source.country}
	end

	def search
		if(params[:query]!=nil)
			@query = params[:query]

			if params[:source_ids]!=nil && !params[:source_ids].blank?
				@selected_source = params[:source_ids]
			end

			if params[:context_id]!=nil &&  !params[:context_id].blank?
				@selected_context = params[:context_id].to_i
			end

			if params[:country_names]!=nil &&  !params[:country_names].blank?
				@selected_country = params[:country_names]
			end

			if params[:page]!=nil
				@page = params[:page].to_i
			else
				@page = 0
			end

			keyword = Keyword.find_by_name(params[:query])

			if (keyword!=nil)
				if (!keyword.visible)
					@links = []
				return
				end
				@links =  UrlLink.joins(:keywords).where("keywords.id = ?",keyword.id)
			else
				@links = UrlLink.where("title like ? ", "%#{params[:query]}%")
			end

			if (@selected_source!=nil)
				@links = @links.where("source_id in (#{@selected_source.join(',')})")
			else
				if (@selected_country!=nil)
					names = @selected_country.collect{|c| "'#{c}'" }.join(',')
					@links = @links.joins(:source).where("sources.country in (#{names })")
				end
			end
			if (@selected_context!=nil)
				@links = @links.joins(:url_contexts).where("url_contexts.keyword_context_id = ? and url_contexts.score > 0.2*url_links.relevancy_score",@selected_context)
			end

			@links = @links.where("relevancy_score > 150")

			if (params[:from]!=nil && params[:to]!=nil)
				@from = Date.strptime("#{params[:from][:year]}/#{params[:from][:month]}/#{params[:from][:day]}","%Y/%m/%d")
				@to = Date.strptime("#{params[:to][:year]}/#{params[:to][:month]}/#{params[:to][:day]}","%Y/%m/%d")
				@from_date = "#{params[:from][:year]}/#{params[:from][:month]}/#{params[:from][:day]}"
				@to_date = "#{params[:to][:year]}/#{params[:to][:month]}/#{params[:to][:day]}"

				@links = @links.where("date(published_on) >= ? and date(published_on) <= ?",@from,@to+1.day)
			end

			if (!params[:from_date].blank? && !params[:to_date].blank?)
				@from_date = params[:from_date]
				@to_date = params[:to_date]
				@from = Date.strptime(params[:from_date],"%Y/%m/%d")
				@to = Date.strptime(params[:to_date],"%Y/%m/%d")
				@links = @links.where("date(published_on)  >= ? and date(published_on) <= ?", @from, @to + 1.day)
			end

			puts @links.to_sql
			@count = @links.count
			@links = @links.order("published_on desc")
			@links = @links.offset(@page*20).limit(20)

		end
	end

	def report
		if(params["article"]!=nil)
			@start_date = Date.new params["article"]["start_date(1i)"].to_i, params["article"]["start_date(2i)"].to_i, params["article"]["start_date(3i)"].to_i
			@end_date = Date.new params["article"]["end_date(1i)"].to_i, params["article"]["end_date(2i)"].to_i, params["article"]["end_date(3i)"].to_i
		else
			@start_date = Date.today - 30.days
			@end_date = Date.today 
		end
		
		@links = UrlLink.relevant_links_in_range(@start_date,@end_date)
		@sources_report = Hash.new
		@context_report = Hash.new
		@links.each do |link|
			unless link.source==nil
				if (@sources_report[link.source.name] == nil)
					@sources_report[link.source.name] = 1
				else
					@sources_report[link.source.name] += 1
				end
			end
			
			unless link.keyword_contexts.each do |k|
				unless k==nil
					if @context_report[k.name] == nil
						@context_report[k.name] = 1
					else
						@context_report[k.name] += 1
					end
				end
			end
		end
		end
		render :report,:layout=>"admin"
	end

	def context

	end
end
