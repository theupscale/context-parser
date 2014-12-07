class UrlLink < ActiveRecord::Base
	belongs_to :source

	has_many :url_keywords,:dependent=>:destroy
	has_many :url_contexts,:dependent=>:destroy

	has_many :keyword_contexts, :through=>:url_contexts
	has_many :keywords, :through=>:url_keywords

	before_save :determine_source,:fill_etag
	def fill_etag
		self.etag = Digest::MD5.hexdigest("#{self.title}-#{self.source.id}")
		puts "Saving Etag #{self.etag}"
	end

	def determine_source
		uri = URI(self.url)
		domain = uri.host.downcase
		source = nil

		Source.all.each do |s|
			if (domain.include?(s.domain_name.downcase))
			source = s
			break
			end
		end
		self.source = source
	end

	def self.with_relevant_context(context=nil,country=nil,source=nil,age_in_days)
		@links = UrlLink.where("relevancy_score >= 130 and published_on >= ?",Date.today - age_in_days.days)
		@links = @links.joins(:source).where("sources.enabled = 1")
		
		if (context!=nil)
			@links = @links.joins(:url_contexts).where("url_contexts.keyword_context_id = ? and url_contexts.score > url_links.relevancy_score*0.20",context)
		end
		if (source!=nil)
			@links = @links.where("source_id = ?",source)
		else
			if (country!=nil)
				@links = @links.where("sources.country = ?",country)
			end
		end

		@links = @links.order("published_on desc")

		@final_links = UrlLink.filter_relevant_links(@links)

		return @final_links
	end

	def self.filter_relevant_links(links)
		final_links = []
		bad_score = 0
		good_score = 0
		links.each do |link|
			add = true
			unless link.url_contexts.empty?
				link.url_contexts.each do |k|
					if k.keyword_context == nil
					link.url_contexts.delete k
					elsif k.keyword_context.is_relevant
					good_score += k.score
					else
					bad_score += k.score
					end
				end
			else
			add = false
			end
			if (good_score > bad_score * 3)
			add = true
			end
			if (add)
			final_links << link
			end
		end
		return final_links
	end

	def self.with_relevant_context_on_date(context=nil,country=nil,source=nil,day)
		@links = UrlLink.where("relevancy_score >= 130 and date(published_on) = ?",day)
		@links = @links.joins(:source).where("sources.enabled = 1")
		
		if (context!=nil)
			@links = @links.joins(:url_contexts).where("url_contexts.keyword_context_id = ? and url_contexts.score > url_links.relevancy_score*0.20",context)
		end
		if (source!=nil)
			@links = @links.where("source_id = ?",source)
		else
			if (country!=nil)
				@links = @links.where("sources.country = ?",country)
			end
		end

		@links = @links.order("published_on desc")

		@final_links = UrlLink.filter_relevant_links(@links)

		return @final_links
	end

	def self.relevant_links_in_range(start_date,end_date)
		@links = UrlLink.where("relevancy_score >= 130 and date(published_on) >= ? and date(published_on) <= ?",start_date,end_date)
		@links = @links.joins(:source).where("sources.enabled = 1")
		@links = @links.order("published_on desc")
		@final_links = UrlLink.filter_relevant_links(@links)
		return @final_links
	end

	def try_fill_published_on
		if (published_on==nil)
			match_data = /(\d\d\d\d)\/(\d\d)\/(\d\d)/.match(self.url)
			if (match_data!=nil)
				year = match_data[1]
				month = match_data[2]
				day = match_data[3]
				date = Date.strptime("#{day}/#{month}/#{year}", '%d/%m/%Y')
			self.published_on = date.to_time
			end

			match_data = /\/(\d\d\d\d\d\d)\//.match(self.url)
			if (match_data!=nil)
				self.published_on = Date.parse(match_data[1])
			end
		end
	end
end
