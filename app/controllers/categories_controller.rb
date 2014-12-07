class CategoriesController < AdminController
	def index
	end

	def new
		@category = Category.new
	end

	def edit
		@category = Category.find(params[:id])
	end

	def delete
		@category =Category.find(params[:id])
		@category.delete
		redirect_to :action=>index
	end
	
	def delete_all
		params[:selected].each do |s|
			k = Category.find(s)
			k.destroy
		end
		redirect_to :action=>:index
	end

	def update
		@category = Category.find(params[:id])
		if (@category.update_attributes(params[:category]))
			redirect_to :action=>:index
		else
			render :edit
		end
	end

	def create
		@category = Category.new(params[:category])
		if (@category.save)
			redirect_to :action=>:index
		else
			render :new
		end
	end
end
