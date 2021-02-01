class ArticlesController < ApplicationController
  load_and_authorize_resource

  before_action :set_article, only: [:show, :edit, :update, :destroy]

  def article_params
    params.require(:article).permit(:title, :topic, :tags, :content, :public)
  end

  # GET /articles or /articles.json
  def index
    @articles = Article.last(5)
    if current_user
      @articles = Article.all
    end
  end

  # GET /articles/1 or /articles/1.json
  def show
     if can? :update, @article, user_id: current_user.id
      @goodboy = true;
     end

    # can use this also, but i think not safe
    #if @article.user_id == current_user.id
    # @me = true
    #end
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
  
    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new
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
      params.require(:article).permit(:title, :tags, :topic, :content)
    end
end
