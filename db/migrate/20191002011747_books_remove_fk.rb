class BooksRemoveFk < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :books, column: "id"
  end
end
