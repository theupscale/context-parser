class UrlPattern < ActiveRecord::Base
  belongs_to :source
  
  def self.find_match(url_string)
    UrlPattern.all.each do |pat|
      r = Regexp.new pat.pattern
      if (r =~ url_string)
        return pat
      end
    end
    return nil
  end
end
