class KeywordRulesController < AdminController
	def index
		unless params[:id]!=nil
			@keyword_rule = KeywordRule.new
		else
			@keyword_rule = KeywordRule.find(params[:id])
		end
	end

	def create
		@keyword_rule = KeywordRule.new(params[:keyword_rule])
		@keyword_rule.save
		redirect_to :controller=>:keyword_contexts,:action=>:create_rule,:id=>@keyword_rule.keyword_context.id
	end

	def update
		@keyword_rule = KeywordRule.find(params[:id])
		@keyword_rule.update_attributes(params[:keyword_rule])
		redirect_to :controller=>:keyword_contexts,:action=>:create_rule,:id=>@keyword_rule.keyword_context.id
	end

	def delete
		@keyword_rule = KeywordRule.find(params[:id])
		@keyword_rule.destroy
		redirect_to :controller=>:keyword_contexts,:action=>:create_rule,:id=>@keyword_rule.keyword_context.id
	end

end
