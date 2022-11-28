class AddColoumnBookRequestHold < ActiveRecord::Migration[5.2]
  def change
    add_column :book_request, :hold, :boolean
  end
end
