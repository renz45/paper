class Posts < ActiveRecord::Base
  attr_accessible :author_id, :content, :tag_id, :title
end
