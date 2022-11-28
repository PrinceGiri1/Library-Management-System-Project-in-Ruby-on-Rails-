json.extract! student, :id, :email, :name, :password, :education, :university, :max_books, :created_at, :updated_at
json.url student_url(student, format: :json)
