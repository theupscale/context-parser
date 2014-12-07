require 'anemone'
require 'digest/md5'

class Source < ActiveRecord::Base
  has_many :url_patterns
  has_many :url_link_dumps
  has_many :url_links
  
  has_many :rss_urls
  
  def to_s
    return domain_name
  end
  
  def self.all_countries
    countries = []
    Source.all.each do |source|
      unless countries.include?(source.country)
        countries << source.country
      end
    end
    return countries
  end
  
  def run_spider(start_url=nil)
    if (start_url == nil)
      start_url = base_url
    end
    
    db = Mongo::Connection.new.db("scraped")
    posts_collection = db["posts"]
    Anemone.crawl(start_url) do |anemone|
      anemone.on_every_page do |page|
        if (page.url.host.downcase.include?(domain_name.downcase))
          if (page.html?)
            puts page.url.path
            etag = Digest::MD5.hexdigest(page.url.path)
            dump = UrlLinkDump.new(:source_id=>self.id,:url=>page.url.to_s,:etag=>etag)
            if (dump.save)
              post = {:url=>page.url.to_s,:html=>page.body}
              posts_collection.insert  post
            end
          end
        end
      end
    end
  end
end
