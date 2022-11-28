json.extract! borrow_history, :id, :date, :is_special, :status, :created_at, :updated_at
json.url borrow_history_url(borrow_history, format: :json)
