class Post < ActiveRecord::Base
  attr_accessible :author_id, :content, :tag_id, :title
  before_save :set_slug
  before_create :set_slug

  def self.to_ar
    @arel_table ||= self.arel_table
    @arel_table
  end

  def self.find_by_url(slug)
    arel_query = self.to_ar[:id].eq(slug.to_i).or(self.to_ar[:cached_slug].eq(slug.to_s))
    self.where(arel_query).first
  end

  def self.all_by_page(args)
    args[:page] ||= 1
    args[:per_page] ||= 5
    args[:cumulative] ||= false
    if args[:cumulative]
      self.limit(args[:per_page]).order('created_at DESC')
    else
      self.offset((args[:page].to_i - 1) * args[:per_page].to_i).limit(args[:per_page]).order('created_at DESC')
    end
  end

  def self.max_pages(args)
    args[:per_page] ||= 5
    (self.count / args[:per_page].to_f).ceil
  end

  def self.next_page(args)
    args[:current_page] ||= 1
    args[:per_page] ||= 5
    next_page = (args[:current_page].to_i || 0) + 1
    if Post.max_pages(per_page: args[:per_page]) > args[:current_page].to_i
      next_page
    end
  end

  # Temporary until the markdown pre_processing is added
  def processed_content
    content
  end

  def to_slug
    self.title.parameterize
  end

  def set_slug
    write_attribute(:cached_slug, self.to_slug)
  end

  def to_param
    cached_slug
  end
end
