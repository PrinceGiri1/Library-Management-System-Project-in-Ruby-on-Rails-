class User < ApplicationRecord
  enum role: {user: 0, librarian: 1, admin: 2}
  after_initialize :set_default_role,:if => :new_record?
  # before_save :copy_data
  # after_save :copy_data

  has_many :students
  has_many :librarians
  accepts_nested_attributes_for :students
  accepts_nested_attributes_for :librarians

  def set_default_role
    self.role ||= :user
  end

  def copy_data
    if self.librarian?
      # if not @user = Librarian.find(self.id)
      @user = User.find(self.id)
      if Librarian.find_by_email(self.email).nil?
        @lib = Librarian.new(email: self.email, password: self.encrypted_password, libraries_id: 1)
        @lib.save
        #   flash[:success] = "Successfully saved data to Librarian model"
        # redirect_to librarians_path

        # else
        #   flash[:error] = "Could not create record"
        # end
      end

        # @user = Librarian.find(self.id)
        # if (nil == @user)
        #   @lib = Librarian.create(email: self.email, name:self.email, password: self.encrypted_password, users_id: self.id)
        #   @lib.save
        # else
        #   @lib = Librarian.create(email: self.email, name:self.email, password: self.encrypted_password, users_id: self.id)
        #   @lib.save
        # end
      #
    elsif self.user?
      # @user = User.find(self.id)
      if Student.find_by_email(self.email).nil?
        @stud = Student.new(email: self.email, password: self.encrypted_password)
        @stud.save
        #   flash[:success] = "Successfully saved data to Student model"
        # redirect_to students_path
        # else
        #   flash[:error] = "Could not create record"
        # end
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      # user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i[facebook]

end
