class HomeController < ApplicationController
  
	def index
		if params[:tag]
			@articles = Article.tagged_with(params[:tag]).paginate(:page => params[:page])
#    elsif params[:date]
#      @articles = Article.
    elsif params[:query].present?
      @articles = Article.search(params[:query]) #, page: params[:page], per_page: 12
      #@articles = articles.paginate(:page => params[:page], :per_page => 12)
		else
			@articles = Article.paginate(:page => params[:page])
    end
    @articles_featured = Article.featured.size != 0 ? Article.featured : Article.order(published_at: :desc).reorder(clicks: :desc).limit(5)
    respond_to do |format|
      format.html
      format.js
    end
	end
	def show
		@article = Article.find(params[:id])
		count= @article.clicks + 1
		@article.update_attributes(:clicks => count)

		respond_to do |format|
			format.html
			format.js
			format.json { render json: @article}
		end
	end
	
	def comments
		@article = Article.find(params[:id])

                respond_to do |format|
                        format.html
                        format.js
                        format.json { render json: @article }
	        end
	end

	def render_comments
		#@article = Article.find(params[:id])
		render :partial => 'comments'
  end

  def search
    if params[:query].present?
      @articles = Article.search(params[:query]).paginate(:page => params[:page])
    else
      @articles = Article.tagged_with(params[:tag]).paginate(:page => params[:page])
    end
  end

  def autocomplete
    #articles = Article.search(params[:query], autocomplete: false, limit: 10).map {|a| [a.title, (url_for :action => 'show', :id => a.id, :only_path => true)]}
    #tags = ActsAsTaggableOn::Tag.where('name like ?', params[:query])
    render json: Article.search(params[:query], autocomplete: false, misspellings: {distance: 2}, limit: 10).map {|a| [a.title, (url_for :action => 'show', :id => a.id, :only_path => true)]}
    #json = { :articles => articles, :tags => tags}.to_json
    #render json: json
  end

end
