class CreateBorrowHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :borrow_histories do |t|
      t.date :date
      t.boolean :is_special
      t.string :status

      t.timestamps
    end
  end
end
