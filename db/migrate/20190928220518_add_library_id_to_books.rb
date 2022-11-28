class AddLibraryIdToBooks < ActiveRecord::Migration[5.2]
  def change
    add_reference :books, :libraries, foreign_key: true
  end
end
