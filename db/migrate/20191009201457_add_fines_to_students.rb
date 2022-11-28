class AddFinesToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :fines, :integer
  end
end
