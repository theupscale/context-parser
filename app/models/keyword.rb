class Keyword < ActiveRecord::Base
	belongs_to :category
	belongs_to :keyword

	has_many :url_keywords,:dependent=>:destroy
	has_many :keyword_rules,:dependent=>:destroy

	has_many :url_links, :through=>:url_keywords
	def self.alias_of(keyword_name)
		keyword = Keyword.find_by_name(keyword_name)
		if (keyword==nil)
			return nil
		else
		return keyword.keyword
		end
	end
end
