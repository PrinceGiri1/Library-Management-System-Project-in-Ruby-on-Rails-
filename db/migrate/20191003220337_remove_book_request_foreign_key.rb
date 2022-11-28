class RemoveBookRequestForeignKey < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :book_request, column: "id"
  end
end
