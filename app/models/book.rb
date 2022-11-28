class Book < ApplicationRecord
  has_one_attached :image

  validates :isbn , :presence => true, :uniqueness => true, format: { with: /[0-9]+/, message: 'Only numbers allowed.'}
  validates :title, :presence => true
  validates :author, :presence => true
  validates :edition, format: { with: /[0-9]*/, message: 'Only numbers allowed.' }
  validates :book_count, presence: true

end
