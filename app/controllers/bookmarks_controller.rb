class BookmarksController < ApplicationController
  def index
    @bookmarks = Bookmark.where(users_id: User.find_by_email(current_user.email))
    @bookmarks_list=[]

    @bookmarks.each do |bookmark|
      d = {}
      book = Book.find(bookmark.books_id)
      d[:id] = book.id
      d[:title] = book.title
      d[:isbn] = book.isbn
      d[:author] = book.author
      d[:language] = book.language
      d[:edition] = book.edition
      d[:cover_image] = book.image
      d[:subject] = book.subject
      d[:published] = book.published
      d[:special_collection] = book.special_collection
      @bookmarks_list.push(d)
    end
  end

  def unbookmark
    bookmark = Bookmark.find_by_books_id(params[:id])
    bookmark.destroy

    redirect_to bookmarks_path, notice: 'Bookmark removed successfully !'
  end
end
