class CascadeDeleteForeignKeys < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :admins, column: "users_id"
    add_foreign_key :admins, :users, column: "users_id", on_delete: :cascade

    remove_foreign_key :book_request, column: "books_id"
    add_foreign_key :book_request, :books, column: "books_id", on_delete: :cascade
    remove_foreign_key :book_request, column: "librarians_id"
    add_foreign_key :book_request, :librarians, column: "librarians_id", on_delete: :cascade
    remove_foreign_key :book_request, column: "students_id"
    add_foreign_key :book_request, :students, column: "students_id", on_delete: :cascade

    remove_foreign_key :bookmarks, column: "books_id"
    add_foreign_key :bookmarks, :books, column: "books_id", on_delete: :cascade
    remove_foreign_key :bookmarks, column: "users_id"
    add_foreign_key :bookmarks, :users, column: "users_id", on_delete: :cascade

    remove_foreign_key :books, column: "libraries_id"
    add_foreign_key :books, :libraries, column: "libraries_id", on_delete: :cascade

    remove_foreign_key :borrow_histories, column: "books_id"
    add_foreign_key :borrow_histories, :books, column: "books_id", on_delete: :cascade
    remove_foreign_key :borrow_histories, column: "students_id"
    add_foreign_key :borrow_histories, :students, column: "students_id", on_delete: :cascade

    remove_foreign_key :libraries, column: "users_id"
    add_foreign_key :libraries, :users, column: "users_id", on_delete: :cascade

    remove_foreign_key :students, column: "users_id"
    add_foreign_key :students, :users, column: "users_id", on_delete: :cascade

    remove_foreign_key :users, column: "libraries_id"
    add_foreign_key :users, :libraries, column: "libraries_id", on_delete: :cascade
    remove_foreign_key :users, column: "students_id"
    add_foreign_key :users, :students, column: "students_id", on_delete: :cascade

  end
end
