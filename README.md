# Library-Management-System-Rails

A web application for managing the library and its operations. This was my project in the "CSC 517: Object Oriented Design and Development" course at NC State University.

Deployed a web application using Ruby on Rails and Heroku that allows students to checkout & return books, librarians to view overdue fines and admin to CRUD libraries, books, users and view borrowing history & fines. Integrated 3rd-party ruby gems like Devise and Pundit to make the app more functional.

* <strong>Heroku App Link:</strong> https://glacial-reaches-87041.herokuapp.com/

### Configuration information:

* <strong>Ruby version:</strong> 2.6.3 : <strong>Rails version:</strong> 5.2.3

* <strong>3rd-party gems used:</strong> Devise, Pundit, OAuth-Facebook

* <strong>Database used:</strong> PostgreSQL

### Pre-configured admin account details:

* Email: admin@admin.com  |  Password: admin

### Testing various features:

* Any user can login from the sign_in page, the homepage will be shown as per the role of the user - Student, Librarian, Admin, and will have the respective links to perform the tasks.

### Additional Functionalities

* No student/librarian should access any private content associated with other student/librarian/admin's account.

* All users can use their Facebook account to log into the system.

### Student:

    View the list of all the libraries: View Libraries

    Edit profile to modify email, name and password: My Profile -> Edit Profile

    View all books: View Books

    Check out/Request: View Books -> Request Book
    
    Return a book: Requested Books -> Return
    
    Delete a reservation request, which has not been approved yet: View Hold/Pending Approval Requests -> Delete Reservation/Hold Request or Cancel Pending Approval Book Request
    
    Search through the books by title or author or publication date or subject: View Books -> Type the search attribute - Search
    
    A student can bookmark the Book by clicking on Bookmark against the book
    
    A student can view the bookmarked books by clicking on View Bookmarked Books
    
    At any given time, a student can borrow a max of 'N' number of books based on their educational level: Undergraduate - 2, Masters - 4, PhD - 6
    
    A student can view the overdue fines for his/her account:
    
    Whenever a book's avaialble count is 0, a student can request the book and a hold request will be placed. As soon as someone returns that Book, it will be issued to the next user on hold.
    
 ### Librarian:  
 
    A librarian can-
    
    Log in with email and password: 
    
    Edit their own profile to choose an existing library. Each librarian can only work for one library.
    
    Edit library attributes.
    
    Add/Remove books to/from a library.
    
    View & Edit book information.
    
    View all books.
    
    View hold requests for any book in the library he/she works in.
    
    For books in the special collection, accept or deny book hold request.
    
    View list of all the books that are checked out from their library.
    
    View the borrowing history of the books from their library.
    
    View the list of students with overdue books from their library along with overdue fine.
    
    
 ### Admin:
 
    Log in with an email and password
    
    Edit profile
    
    Create/Modify Librarian or Student accounts
    
    Create/Modify/Delete Libraries and Books
    
    View the list of users (students and librarians) and their profile details (except password)
    
    View the list of books, along with detailed information
    
    View the list of book hold requests
    
    View the list of Checked out books
    
    View the list of students with books overdue (along with overdue fines)
    
    View the borrowing history of each book
    
    Delete Student/Book/Librarian from the system
    
