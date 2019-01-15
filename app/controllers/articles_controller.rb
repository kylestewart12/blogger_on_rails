class ArticlesController < ApplicationController
    include ArticlesHelper
    before_action :require_login, except: [:index, :show]

    def index
        @articles = Article.all
    end
    
    def show
        @article = Article.find(params[:id])
        @article.increment_view_count
        
        @comment = Comment.new
        @comment.article_id = @article.id
    end

    def new
        @article = Article.new
    end

    def create
        @article = Article.new(article_params)
        @article.save

        flash.notice = "Article '#{@article.title}' Created!"

        redirect_to article_path(@article)
    end

    def edit
        @article = Article.find(params[:id])
    end

    def update
        @article = Article.find(params[:id])
        @article.update(article_params)

        flash.notice = "Article '#{@article.title}' Updated!"

        redirect_to article_path(@article)
    end

    def destroy
        @article = Article.find(params[:id])
        @article.destroy

        flash.notice = "Article '#{@article.title}' Deleted!"
        
        redirect_to articles_path
    end

    def most_popular
        view_counts = Article.all.map(&:view_count)
        most_pop = view_counts.max
        @article = Article.find_by(view_count: most_pop)
        redirect_to article_path(@article)
    end
    
    def random_article
        article_ids = Article.all.map(&:id)
        random_id = article_ids.sample
        @article = Article.find(random_id)
        redirect_to article_path(@article)
    end
    
end
