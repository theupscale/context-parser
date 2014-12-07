class KeywordContext < ActiveRecord::Base
	
	has_many :keyword_rules,:dependent=>:destroy
	has_many :url_contexts,:dependent=>:destroy

	has_many :url_links, :through=>:url_contexts
	
	def self.all_contexts_for_keyword(keyword)
		return KeywordContext.joins(:keyword_rules=>:keyword).where("keywords.name = ?",keyword)
	end

	def self.relevant_contexts
		return KeywordContext.where("is_relevant = 1")
	end

	def self.relevant_contexts
		return KeywordContext.where("is_relevant = 1")
	end

	def must_have_rules
		return KeywordRule.joins(:keyword_context).where("mode=? and keyword_context_id = ?","MUST_HAVE",self.id)
	end

	def atleast_this_rules
		return KeywordRule.joins(:keyword_context).where("mode=? and keyword_context_id = ?","ATLEAST_THIS",self.id)
	end

	def must_not_rules
		return KeywordRule.joins(:keyword_context).where("mode=? and keyword_context_id = ?","MUST_NOT",self.id)
	end

	def should_not_rules
		return KeywordRule.joins(:keyword_context).where("mode=? and keyword_context_id = ?","SHOULD_NOT",self.id)
	end

	def processed_url_links(source_id=nil,selected_country=nil,start_date=nil,end_date=nil)
		links = nil
		puts start_date
		if (selected_country==nil)
			if (source_id==nil)
				links = UrlLink.joins(:keyword_contexts).where("keyword_contexts.id = ? and parsed = 1",self.id).order("published_on desc")
			else
				links = UrlLink.joins(:keyword_contexts).where("keyword_contexts.id = ? and parsed = 1 and source_id = ?",self.id,source_id)
			end
		else
			links = UrlLink.joins(:keyword_contexts).where("keyword_contexts.id = ? and parsed = 1",self.id)
			links = links.joins(:source).where("sources.country = ?",selected_country)
		end
		if (start_date!=nil)
			if (end_date==nil)
				end_date = Date.today
			end
			links = links.where("published_on <= ? and published_on >= ?",end_date,start_date)
		end
		links = links.order("published_on desc")
	end

end
