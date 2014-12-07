# encoding: utf-8
include CommonMethods

load 'parser/url_fetch.rb'
load 'parser/keyword_parser.rb'
class UrlLinkDump < ActiveRecord::Base
	belongs_to :source
	validates :etag, :uniqueness=>true

	scope :unprocessed, where("processed = false").order("published_on desc")
	
	def check_etag
		return self.etag == Digest::MD5.hexdigest("#{self.title}-#{self.source.id}")
	end

	def process
		data = KeywordParser.load_keywords
		keywords = data[0]
		pings = data[1]

		words =  UrlFetch.get_text(self.url)
		if (words[:body_relevant])
			boosts = {:url_words=>5,:title=>4,:description=>3,:keywords=>3,:content=>1}
		else
			boosts = {:url_words=>5,:title=>4,:description=>3,:keywords=>3,:content=>0.1}
		end
		
		puts words

		self.title = not_null(words[:title],self.title)

		if (self.description==nil || self.description.empty?)
			self.description = words[:description]
		end

		final_context_report = Hash.new
		final_keyword_report = Hash.new

		boosts.keys.each do |text_type|
			puts "The boost is #{text_type}"
			text = words[text_type]
			if (text == nil || text.empty?)
				next
			end

			text = text.squish

			keyword_report = KeywordParser.density_report(text,pings,keywords)
			keyword_report = KeywordParser.consolidate_keywords(keyword_report)
			keyword_report = KeywordParser.calculate_keyword_scores(keyword_report,text.length)

			keyword_report.keys.each do |k|
				if (final_keyword_report.keys.include? k)
				final_keyword_report[k] += keyword_report[k] * boosts[text_type]
				else
				final_keyword_report[k] = keyword_report[k] * boosts[text_type]
				end
			end

			context_report = KeywordParser.context_relevancy_report(keyword_report)

			context_report.keys.each do |context|
				final_context_report[context] = 0 if final_context_report[context] == nil
				final_context_report[context] += context_report[context] * boosts[text_type]
			end
		end

		puts final_keyword_report

		final_context_report = UrlLinkDump.weigh_contexts(final_context_report)

		if (!final_context_report.empty?)
			url_link = UrlLink.find_by_url(self.url)
			
			if (url_link==nil)
				url_link = UrlLink.new(:url=>self.url)
				url_link.title = not_null(words[:title],self.title)
				url_link.description = not_null(words[:description],self.description)
				url_link.image_url = words[:image_link]
				url_link.published_on = self.published_on
			else
				url_link.published_on = self.published_on
			end
			
			url_link.save

			url_link.url_contexts.clear

			relevancy_score = 0

			final_context_report.keys.each do |context|
				uc = UrlContext.new
				uc.keyword_context = KeywordContext.find_by_name(context)
				uc.score = final_context_report[context]

				if (uc.keyword_context.is_relevant)
					relevancy_score += uc.score
				else
					relevancy_score -= uc.score
				end

				url_link.url_contexts << uc
			end

			url_link.url_keywords.clear
			final_keyword_report.keys.each do |keyword|
				temp_key = Keyword.find_by_name(keyword)
				uk = UrlKeyword.new
				uk.keyword = temp_key
				uk.score = final_keyword_report[keyword]
				url_link.url_keywords << uk
			end

		url_link.relevancy_score = relevancy_score
		url_link.parsed = true
		url_link.save
		end

		self.processed = true
		self.save

		#clean_up
		return url_link

	end

	def clean_up
		db = Mongo::Connection.new.db("scraped")
		posts_collection = db["posts"]
		posts_collection.remove({:url=>url})
	end

	def self.weigh_contexts(context_report)
		puts "The context Report is #{context_report}"
		final_context_report = Hash.new

		sum = 0
		count = 0

		context_report.keys.each do |c|
			context = KeywordContext.find_by_name(c)
			score = context.weight * context_report[c]
			final_context_report[c] = score
			sum  += score
			count += 1
		end

		puts "The Final context Report is #{final_context_report}"

		if (sum==0)
		return final_context_report
		end

		mean = sum/count

		to_remove = []
		final_context_report.keys.each do |c|
			if (final_context_report[c] < (mean*0.1))
			to_remove << c
			end
		end

		to_remove.each do |c|
			final_context_report.delete(c)
		end

		puts "The Final context Report is #{final_context_report}"
		return final_context_report
	end
end