class UrlPatternsController < AdminController
  def index
    if (params[:id]!=nil)
      @url_pattern = UrlPattern.find(params[:id])
    else
      @url_pattern = UrlPattern.new
    end
    
    if (params[:source_id]!=nil && params[:id]==nil)
      @url_pattern.source_id = params[:source_id]
    end
  end

  def new
    redirect_to :action=>:index
  end
  
  def check_pattern
    if (params[:url]!=nil)
      @pat = UrlPattern.find_match(params[:url])
    end
  end

  def create
    @url_pattern = UrlPattern.new(params[:url_pattern])
    if @url_pattern.save
      redirect_to :action=>:index
    else
      render :index
    end
  end

  def edit
    redirect_to :action=>:index, :id=>params[:id]
  end

  def update
    @url_pattern = UrlPattern.find(params[:id])
    if @url_pattern.update_attributes(params[:url_pattern])
      redirect_to :action=>:index
    else
      render :index
    end
  end

  def delete
  end
end
