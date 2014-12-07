class KeywordsController < AdminController
	def index
		if (params[:query]!=nil)
			@keywords = Keyword.where("name like ?","%#{params[:query]}%").order("category_id asc,name asc")
		else
			@keywords = Keyword.order("category_id asc,name asc")
		end
	end

	def edit
		@keyword = Keyword.find(params[:id])
	end

	def alias
		@base_keyword = Keyword.find(params[:id])
		@keyword = Keyword.new(:name=>@base_keyword.name,:category=>@base_keyword.category,:keyword=>@base_keyword)
		render :new
	end

	def update
		@keyword = Keyword.find(params[:id])
		if @keyword.update_attributes(params[:keyword])
			redirect_to :action=>:index
		else
			render :edit
		end
	end

	def new
		@keyword = Keyword.new
	end

	def delete
		@keyword=Keyword.find(params[:id])
		@keyword.delete
		redirect_to :action=>index
	end
	
	def delete_all
		params[:selected].each do |s|
			k = Keyword.find(s)
			k.destroy
		end
		redirect_to :action=>:index
	end

	def create
		@keyword = Keyword.new(params[:keyword])
		if (@keyword.name.include?(","))
			keywords = @keyword.name.split(",")
			keywords.each do |key|
				keyword = Keyword.new
				keyword.name = key.strip
				if (Keyword.find_by_name(key.strip)==nil)
				keyword.category = @keyword.category
				keyword.keyword = @keyword.keyword
				keyword.save
				end
			end
			redirect_to :action=>:index
		else
			if @keyword.save
				redirect_to :action=>:index
			else
				render :new
			end
		end
	end
end
