class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    @tags = Tag.limit(5)
    if !params.key?("q")
      @articles = Article.all.order(created_at: :desc)
    else 
      @articles = Article.where("lower(title) LIKE '%#{params[:q].downcase}%'" ).order(created_at: :desc)
    end
    @params = params
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    article = Article.find(params[:id])
    article.views_count = article.views_count == nil ? 1 : article.views_count+1
    article.save
    @article = article

    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end

  # GET /articles/new
  def new
    @article = Article.new
    @tags = @article.tags.map { |tag| tag.name }
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
    @tags = @article.tags.map { |tag| tag.name }
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    
    @tags = params[:tags_field].split(/\s*,\s*/)
    tags = @tags.map{ |tag| Tag.find_or_create_by(name: tag) } 
    @article.tags.clear
    @article.tags << tags

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    @tags = params[:tags_field].split(/\s*,\s*/)
    tags = @tags.map{ |tag| Tag.find_or_create_by(name: tag) } 
    @article.tags.clear
    @article.tags << tags

    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :body)
    end

    def tags_params
      params.permit(:tag_fields)
    end
end
