UrlLink.all.each do |url_link|
  match_data = /(\d\d\d\d)\/(\d\d)\/(\d\d)/.match(url_link.url)  
  if (match_data!=nil)
    year = match_data[1]
    month = match_data[2]
    day = match_data[3]
    
    puts "#{day}/#{month}/#{year}"
    date = Date.strptime("#{day}/#{month}/#{year}", '%d/%m/%Y')
    
    url_link.published_on = date.to_time
    url_link.save
  end
end