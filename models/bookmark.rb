require 'active_record'

class Bookmark < ActiveRecord::Base
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates :url, presence: true, uniqueness: true
  validates :title, presence: true

  def tag_list=(names)
    self.tags = names.split(',').map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end

  def tag_list
    tags.map(&:name).join(', ')
  end
end

class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy
  has_many :bookmarks, through: :taggings

  validates :name, presence: true, uniqueness: true
end

class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :link
end
