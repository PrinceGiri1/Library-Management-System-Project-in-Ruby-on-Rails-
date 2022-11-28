class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.string :email
      t.string :name
      t.string :password
      t.string :education
      t.string :university
      t.integer :max_books

      t.timestamps
    end
  end
end
