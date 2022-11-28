Rails.application.routes.draw do

  resources :borrow_histories
  # so that only authenticated user can access these pages.
  # Refer: https://github.com/plataformatec/devise/wiki/How-To:-Require-authentication-for-all-pages
  # and https://github.com/plataformatec/devise/wiki/How-To:-Define-resource-actions-that-require-authentication-using-routes.rb
  authenticate :user do
    # root 'test_home_page#index'
    get 'homepage', to: 'test_home_page#index', as: 'user_homepage'
    get 'home/index'
    resources :admins
    resources :librarians
    resources :students
    resources :books
    resources :libraries
    resources :bookmarks

    get 'book/show'
    get 'book/edit'
    get 'book/destroy'
    get 'book/create'
    get 'book/new'
    get 'urls/new'
  end

  root 'home#index'
  get 'page2', to: 'page2#index', as: 'page2'
  get 'book_request', to: 'books#book_request', as: 'book_request'

  # get 'borrow_history', to: 'borrow_histories#'

  get 'bookmarked', to: 'books#bookmarked', as: 'bookmarked'
  get 'unbookmarked', to: 'bookmarks#unbookmark', as: 'unbookmarked'
  get 'list_special_book_request', to: 'librarians#list_special_book_request', as: 'list_special_book_request'
  get 'approve_book_request', to: 'librarians#approve_book_request', as: 'approve_book_request'
  get 'approve_librarian', to: 'admins#approve_librarian', as: 'approve_librarian'
  get 'librarian_requests', to: 'admins#librarian_requests', as: 'librarian_requests'
  get 'requests', to: 'book_requests#index', as: 'requests'
  get 'returns', to: 'book_requests#returns', as: 'returns'
  get 'hold_requests', to: 'book_requests#hold_requests', as: 'hold_requests'
  get 'delete_hold_request', to: 'book_requests#delete_hold_request', as: 'delete_hold_request'
  # devise_for :users, :controllers => { registrations: 'registrations'}

  get 'fb_details_new', to: 'ask_details_fb_login#new', as: 'fb_details_new'
  get 'fb_details_create', to: 'ask_details_fb_login#create', as: 'fb_details_create'

  devise_for :users, :controllers => { registrations: 'registrations', omniauth_callbacks: 'users/omniauth_callbacks'}




  # devise_scope :user do
  #   # to change the page displayed after sign in. Refer: https://stackoverflow.com/a/25243422/6543250
  #   get 'user_root', :to => 'registrations#after_sign_in_path_for'
  # end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
