class MoreFKs < ActiveRecord::Migration[5.2]
  def change
    add_reference :libraries, :users, foreign_key: true
    add_reference :admins, :users, foreign_key: true
    add_reference :students, :users, foreign_key: true
  end
end
