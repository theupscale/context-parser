require 'nokogiri'
require 'open-uri'

module UrlFetch
  
  def get_text(url)
    xpath_found = false
    puts "Parsing #{url}"
    if (url.starts_with?("https"))
      url = url.gsub("https","http")
    end
    uri = URI(url)
    
    domain = uri.host.downcase
    source = nil
    
    Source.all.each do |s|
      if (domain.downcase.include?(s.domain_name.downcase))
        source = s
        break
      end
    end
    
    if (source==nil)
      puts "No source found for #{url}"
      return ""
    end
    
    puts "##==>Source is #{source.domain_name}"
    
    pattern = nil
    if (source!=nil)
      source.url_patterns.each do |pat|
        r = Regexp.new pat.pattern
        if (r =~ url)
          pattern = pat
        end
      end
    end
    
    content_xpath = "//body"
    
    if (pattern!=nil)
      puts "Yes! Pattern found!! Trying Xpath"
      content_xpath = pattern.content_xpath
    else
      if (source!=nil)
        content_xpath = source.generic_pattern
      end
    end
    
    db = Mongo::Connection.new.db("scraped")
    posts_collection = db["posts"]
    post = posts_collection.find(:url=>url).next
    html = nil
    if (post!=nil)
      html = post["html"]
    end
    
    if (html!=nil)
      doc = Nokogiri::HTML(html)
    else
      doc = Nokogiri::HTML(open(url))
    end
    
    content_node = doc.xpath(content_xpath)
    
    if (content_node.empty?)
      puts "Oh no! No Xpath not found!"
      content_node = doc.xpath("//body")
    else
      puts "Yess! Content Xpath worked"
      xpath_found = true
    end
    
    content_node.search("script").each {|el| el.unlink}
    puts content_node.text.squish
    
    results = Hash.new
    image_tag = doc.xpath(source.image_xpath)
    if (image_tag!=nil)
      results[:image_link] = image_tag.text
    end
    results[:url_words] = uri.path.gsub("/"," ").gsub("-"," ").gsub("_"," ")
    results[:title] = doc.xpath("//title").inner_text
    results[:description] = not_null(doc.xpath("//meta[name='description']").inner_text,doc.xpath("//meta[name='og:description']").inner_text)
    results[:keywords] = doc.xpath("//meta[name='keywords']").inner_text
    results[:content] = content_node.text.squish
    results[:body_relevant] = xpath_found
      
    return results 
  end
  
  module_function :get_text
end