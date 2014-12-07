namespace :janitor do
  
  task :cleanup_duplicates => :environment do
    @links = UrlLink.all
    etags = []
    @links.each do |l|
      if (etags.include? l.etag)
        puts "Duplicate Found!!"
        l.destroy
      else
        etags << l.etag
      end
    end
  end
  
  task :regenerate_etag =>:environment do 
    UrlLinkDump.all.each do |u|
      puts u.title
      u.etag = Digest::MD5.hexdigest("#{u.title}-#{u.source_id}")
      u.save
    end
  end
  
  task :check_etags =>:environment do 
    UrlLinkDump.where("published_on > ?",Date.today - 2.days).order("published_on asc").each do |u|
      if !(u.check_etag)
        puts u.title
        puts u.source_id
        puts u.published_on
        puts u.etag
      end
    end
  end
  
  task :clean_config => :environment do 
    UrlContext.all.each do |uc|
      uc.destroy
    end
    UrlKeyword.all.each do |uk|
      uk.destroy
    end
  end

end
