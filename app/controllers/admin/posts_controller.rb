class Admin::PostsController < Admin::ApplicationController
  include PostsHelper

  before_filter :find_post, except: [:create, :new, :index]
  respond_to :html, :json, :js

  def index
    @published_posts = Post.published
    @draft_posts = Post.drafts
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

  def render_preview
    sleep 1
    respond_with({title: params[:post][:title], content: markdown(params[:post][:content])}.to_json, location: nil)
  end

  def update
    if @post.update_attributes(params[:post])

      if @post.draft?
        flash[:notice] = 'Draft Updated'
      else
        flash[:notice] = 'Post Updated'
      end

      redirect_to admin_root_path
    else
      flash[:error] = @post.errors.messages

      format.html { render :edit }
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