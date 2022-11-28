class AddFkBorrowHistory < ActiveRecord::Migration[5.2]
  def change
    add_reference :borrow_histories, :books, foreign_key: true
    add_reference :borrow_histories, :students, foreign_key: true

  end
end
