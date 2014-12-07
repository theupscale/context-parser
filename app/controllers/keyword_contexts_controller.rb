# encoding: utf-8
load 'parser/keyword_parser.rb'
class KeywordContextsController < AdminController
	def index

	end

	def show
		render :index
	end

	def new
		@context = KeywordContext.new
	end

	def create_rule
		@context = KeywordContext.find(params[:id])
		@keyword_rule = KeywordRule.new(:keyword_context=>@context)
		@rules = KeywordRule.joins(:keyword).where("keyword_context_id = ?",@context.id)
		if (params[:query]!=nil)
			@rules = @rules.where("keywords.name like ?","%#{params[:query]}%")
		end
		@rules = @rules.order("keywords.name asc")
	end

	def create
		@context = KeywordContext.new(params[:keyword_context])
		if(@context.save)
			flash[:message] = "Saved"
			redirect_to :action=>:index
		else
			render :new
		end
	end

	def edit
		@context = KeywordContext.find(params[:id])
	end

	def update
		@context = KeywordContext.find(params[:id])
		if(@context.update_attributes(params[:keyword_context]))
			flash[:message] = "Saved"
			redirect_to :action=>:index
		else
			render :edit
		end
	end
	
	def delete_all
		params[:selected].each do |s|
			kr = KeywordRule.find(s)
			kr.destroy
		end
		redirect_to :action=>:create_rule,:id=>params[:id]
	end

	def test_rules
		render 'test'
	end

	def do_test
		data = KeywordParser.load_keywords
		keywords = data[0]
		pings = data[1]

		@text = params[:test_input]
		@text = @text.squish
		@report = KeywordParser.density_report(@text,pings,keywords)
		@report = KeywordParser.consolidate_keywords(@report)
		@report = KeywordParser.calculate_keyword_scores(@report,@text.length)
		@context_report = KeywordParser.context_relevancy_report(@report)
		render 'test'
	end

	def delete
		@context=KeywordContext.find(params[:id])
		@context.delete
		redirect_to :action=>index
	end
end
