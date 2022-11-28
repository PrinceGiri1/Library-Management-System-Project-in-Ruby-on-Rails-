class LibrariansAndUserTables < ActiveRecord::Migration[5.2]
  def change
    #remove_foreign_key :librarians, column: "users_id"
    remove_foreign_key :librarians, column: "libraries_id"
    add_reference :users, :libraries,  foreign_key: true
    add_reference :users, :students, foreign_key: true
  end
end
