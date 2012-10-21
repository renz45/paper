class Post < ActiveRecord::Base
  include PostsHelper
  attr_accessible :author_id, :content, :tag_id, :title, :draft
  
  before_save :set_processed_content
  before_save :set_slug
  before_create :set_slug

  # Public: find a post based on a url slug, the post id or slug is valid
  #
  # slug - The post id or slug
  #
  # Examples
  #
  # Returns the post
  def self.find_by_url(slug)
    arel_query = self.arel_table[:id].eq(slug.to_i).or(self.arel_table[:cached_slug].eq(slug.to_s))
    self.where(arel_query).first
  end

  # Public: Returns an array of posts based on a page and per_page arg
  #
  # args - The Hash options used to refine the selection (default: {}):
  #             :page - Page to display posts from, defaults to 1
  #             :per_page - How many posts to display per page, defaults to 5
  #             :cumulative - A boolean value, this indicates to to return all posts up to the page given
  #                           useful for 'more' buttons.
  #
  # Returns the array of posts
  def self.all_by_page(args)
    page = (args[:page] || 1).to_i
    per_page = (args[:per_page] || 5).to_i
    cumulative = args[:cumulative] || false
    if args[:cumulative]
      self.limit(per_page).order('created_at DESC')
    else
      self.offset((page - 1) * per_page).limit(per_page).order('created_at DESC')
    end
  end

  # Public: Finds the next post given the current page and posts per page
  #         This is used primairly for setting an anchor jump to link for the 'more' button
  #
  # args - The Hash options used to refine the selection (default: {}):
  #             :page - Current page of posts being shown
  #             :per_page - Current posts perpage
  #
  # Examples
  #
  #   multiplex('Tom', 4)
  #   # => 'TomTomTomTom'
  #
  # Returns the duplicated String.
  def self.find_next(args)
    page = (args[:page] || 1).to_i
    per_page = (args[:per_page] || 5).to_i
    scope = args[:scope] || :all
    self.offset(page * per_page).order('created_at DESC').method(scope).call.first
  end

  # Public: Find the number of max pages of posts given a per_page argument
  #
  # args - The Hash options used to refine the selection (default: {}):
  #             :per_page - Number of posts per page
  #
  # Returns the number of pages as an integer
  def self.max_pages(args)
    per_page = args[:per_page] ||= 5
    scope = args[:scope] || :all
    (self.method(scope).call.count / per_page.to_f).ceil
  end

  # Public: Displays the next page number, returns nil if the current page is the last page
  #
  # args - The Hash options used to refine the selection (default: {}):
  #             :current_page - Current page
  #             :per_page - posts per page to be displayed
  #
  # Returns next page number as an integer
  def self.next_page(args)
    args[:current_page] ||= 1
    args[:per_page] ||= 5
    scope = args[:scope] || :all
    next_page = (args[:current_page].to_i || 0) + 1
    if Post.max_pages(per_page: args[:per_page], scope: scope) > args[:current_page].to_i
      next_page
    end
  end

  # Public: Return all posts that are drafts
  #
  # Returns array of posts where draft: true
  def self.drafts
    self.where(draft: true).order('created_at DESC')
  end

  # Public: Return all posts that are published, draft: false
  #
  # Returns array of posts where draft: false
  def self.published
    self.where(draft: false).order('created_at DESC')
  end

  # Temporary until the markdown pre_processing is added
  def processed_content
    self.read_attribute(:processed_content).html_safe
  end

  # Public: converts the title to a slug
  #
  # Returns title convert to a slug string
  def to_slug
    self.title.parameterize
  end

  def to_param
    cached_slug
  end


  private


  # Public: Sets the cached slug value
  #
  # Returns slug
  def set_slug
    write_attribute(:cached_slug, self.to_slug)
  end

  def set_processed_content
    write_attribute(:processed_content, markdown(self.content))
  end
end
