class AddBookmarksTable < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|

    end

    add_reference :bookmarks, :books,  foreign_key: true
    add_reference :bookmarks, :users, foreign_key: true
  end
end
