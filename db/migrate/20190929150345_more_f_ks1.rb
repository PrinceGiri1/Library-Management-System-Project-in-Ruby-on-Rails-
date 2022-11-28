class MoreFKs1 < ActiveRecord::Migration[5.2]
  def change
    add_reference :librarians, :users, foreign_key: true
  end
end
