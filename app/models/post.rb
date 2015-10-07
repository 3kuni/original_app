class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :article, presence: true
  validates :author, presence: true



end
