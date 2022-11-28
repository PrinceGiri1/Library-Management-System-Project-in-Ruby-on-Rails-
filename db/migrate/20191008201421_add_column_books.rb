class AddColumnBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :available_count, :integer
  end
end
