class MoreFKs3 < ActiveRecord::Migration[5.2]
  def change
    add_reference :librarians, :libraries, foreign_key: true
  end
end
