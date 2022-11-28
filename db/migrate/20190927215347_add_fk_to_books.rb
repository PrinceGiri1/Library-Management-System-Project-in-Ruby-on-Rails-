class AddFkToBooks < ActiveRecord::Migration[5.2]
  def change
    add_reference :libraries, foreign_key: {to_table: :books}
  end
end
