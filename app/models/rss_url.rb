require 'rss'
class RssUrl < ActiveRecord::Base
	belongs_to :source
	
	def is_valid?
		url = self.url
		puts id
		puts url
		begin
			open(url) do |rss|
				feed = RSS::Parser.parse(rss)
				feed.items.each do |item|
					begin
						temp_link = URI(item.link)
					rescue Exception=>e
			
					end
				end
			end
		rescue Exception=>e
			puts e.message
			puts e.backtrace
			return false
		end
		return true
	end
	
end
