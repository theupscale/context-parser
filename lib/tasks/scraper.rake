require 'rss'
require 'nokogiri'

namespace :scraper do

  desc "Go scrape all the latest RSS feeds"
  task :from_base_url => :environment do
    Source.all.each do |source|

    end
  end

  desc "Go scrape all the latest RSS feeds"
  task :from_rss => :environment do
    db = Mongo::Connection.new.db("scraped")
    posts_collection = db["posts"]

    RssUrl.all.each do |rss_url|
      url = rss_url.url
	    begin
        open(url) do |rss|
    			feed = RSS::Parser.parse(rss)
    			puts "Title: #{feed.channel.title}"
    			puts "Feed counts #{feed.items.count}"
    			feed.items.each do |item|
    			  begin
      				temp_link = URI(item.link)
      				if temp_link.host.downcase.include?("google.com")
      				  hash = Rack::Utils.parse_query temp_link.query
      				  link = URI(hash["url"])
      				else
      				link = temp_link
      				end
      				description =  Nokogiri::HTML(item.description).inner_text.squish rescue nil
      				puts item.title
      				puts "#{item.title}-#{rss_url.source.id}"
      				etag = Digest::MD5.hexdigest("#{item.title}-#{rss_url.source.id}")
      				puts etag
      				dump = UrlLinkDump.new(:source_id=>rss_url.source.id,:url=>link.to_s,:etag=>etag,:published_on=>item.pubDate,:title=>item.title,:description=>description)
      				puts dump.check_etag
      				puts "#{link.path} #{item.pubDate}"
      				if (dump.save)
      				  puts dump.description
      				  doc = Nokogiri::HTML(open(link))
      				  post = {:url=>link.to_s.force_encoding("ISO-8859-1").encode("UTF-8"),:html=>doc.to_s.force_encoding("ISO-8859-1").encode("UTF-8")}
      				  posts_collection.insert post
      				end
    			  rescue Exception=>e
      				puts e.message
      				puts e.backtrace
    			  end
    	    end
  	    end
    	rescue Exception=>ex
    			puts "Trouble parsing feed document"
    			puts ex.backtrace
      end
    end
  end

  desc "Parse all unprocessed"
  task :parse_all => :environment do
    UrlLinkDump.unprocessed.each do |u|
      begin
        u.process
      rescue Exception=>e
        puts e.message
        puts e.backtrace
      end
    end
  end
  
  task :clean_mongo => :environment do 
    db = Mongo::Connection.new.db("scraped")
    posts = db["posts"]
    posts.remove()
  end

end
