class HomeController < ApplicationController
  
	def index
		if params[:tag]
			@articles = Article.tagged_with(params[:tag])
#    elsif params[:date]
#      @articles = Article.
		else
			@articles = Article.paginate(:page => params[:page], :per_page => 12)
    end
    @articles_featured = Article.featured.size != 0 ? Article.featured : Article.order(published_at: :desc).reorder(clicks: :desc).limit(5)
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

end
