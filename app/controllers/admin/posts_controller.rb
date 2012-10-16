class Admin::PostsController < Admin::ApplicationController
  before_filter :find_post, except: [:create, :new, :index]
  respond_to :html, :json

  def index
    get_posts
    respond_with(@posts)
  end

  def show

  end

  def new
    @post = Post.new
  end

  def edit

  end

  def create
    @post = Post.new(params[:post])
    if @post.save

      if @post.draft?
        flash[:notice] = 'Draft created'
      else
        flash[:notice] = 'Post Published'
      end

      get_posts
      render :index
    else
      flash[:error] = @post.errors.messages
      render :edit
    end
  end

  def update
    if @post.update_attributes(params[:post])

      if @post.draft?
        flash[:notice] = 'Draft Updated'
      else
        flash[:notice] = 'Post Updated'
      end

      get_posts
      render :index
    else
      flash[:error] = @post.errors.messages
      render :edit
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = 'Post Deleted'
    redirect_to admin_posts_url
  end

  private

  def find_post
    @post = Post.find_by_url(params[:id])
  end

  def get_posts
    @posts = Post.all_by_page(params)
  end
end