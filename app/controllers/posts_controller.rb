class PostsController < ApplicationController
  before_filter :find_post
  respond_to :html, :json

  def index
    get_posts
    respond_with(@posts)
  end

  def show

  end

  private

  def find_post
    @post = Post.find_by_url(params[:id])
  end

  def get_posts
    @posts = Post.all_by_page(params)
  end
end