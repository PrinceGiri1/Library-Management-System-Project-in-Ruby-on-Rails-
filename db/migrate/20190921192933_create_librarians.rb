class CreateLibrarians < ActiveRecord::Migration[5.2]
  def change
    create_table :librarians do |t|
      t.string :email
      t.string :name
      t.string :password
      t.string :library

      t.timestamps
    end
  end
end
