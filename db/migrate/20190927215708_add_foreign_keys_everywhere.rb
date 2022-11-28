class AddForeignKeysEverywhere < ActiveRecord::Migration[5.2]
  def change

    # remove_foreign_key :book_request
    # remove_foreign_key :books
    # remove_foreign_key :libraries
    # remove_foreign_key :librarians
    # remove_foreign_key :students

    add_foreign_key :book_request, :books, column: "id"
    # add_foreign_key :book_request, :libraries, column: "id"
    # add_foreign_key :book_request, :students, column: "id"
    add_foreign_key :books, :libraries, column: "id"


  end
end
