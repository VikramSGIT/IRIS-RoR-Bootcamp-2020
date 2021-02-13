class ArticlesController < ApplicationController
  load_and_authorize_resource
  include Pagy::Backend

  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # GET /articles or /articles.json
  Pagy::VARS[:items] = 4
  def index
    @pagy, @articles = pagy(Article.order("views DESC").all)
    if current_user
      if session[:private_access] > 0
        @im = true
      else
        @id = current_user.id
        flash[:notice] = "Private Access Limit Exhausted!!"
      end
      if !session[:private_access]
        session[:private_access] = 5
      end
    end
  end

  # GET /articles/1 or /articles/1.json
  def show
    if current_user
      if can? :show, @article, user_id:current_user.id
        @im = true
      end
      if can? :update, @article, user_id: current_user.id
        @goodboy = true;
      end
      if @article.views
        views = @article.views + 1
        @article.views = views
      else
        @article.views = 1
      end
      if !@article.public
        session[:private_access] -= 1
        current_user.private_access -= 1
        current_user.save
      end
      @article.save
      respond_to do |format|
          format.html
          format.pdf do
            render pdf: "Article No. #{@article.id}",
            page_size: 'A4',
            template: "articles/show.html.erb",
            layout: "application.html.erb",
            orientation: "Portrait",
            zoom: 1,
            dpi: 72
        end
      end
    end
    # can use this also, but i think not safe
    #if @article.user_id == current_user.id || session[:admin]
    # @too = true
    #end
  end

  # POST /articles or /articles.json
  def create
    if current_user
      @article = Article.new(article_params)
      @article.user_id = current_user.id
      @article.views = 1
      if @article.save
        $new_article = @article
        redirect_to @article, notice: 'Article was successfully created.'
      else
        render :new
      end
    else
      redirect_to @article, notice: 'Login to continue.'
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :tags, :topic, :content, :public, :image)
    end

    def html
      render html: "articles/show"
    end
end
