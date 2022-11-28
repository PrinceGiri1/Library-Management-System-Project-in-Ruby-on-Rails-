require 'rails_helper'

RSpec.describe Student, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  #
  #

  context 'validation tests' do

    it 'ensures email is present' do
      student = Student.new(name: 'Student1', university: 'NCSU', education: 'Undergraduate', max_books: 2)
      expect(student).to_not be_valid
    end

    it 'ensures name is present' do
      student = Student.new(email: 'student1@g.com', university: 'NCSU', education: 'Undergraduate', max_books: 2)
      expect(student).to_not be_valid
    end

    it 'ensures university is present' do
      student = Student.new(email: 'student1@g.com', name: 'Student1', education: 'Undergraduate', max_books: 2)
      expect(student).to_not be_valid
    end

    it 'ensures education is present' do
      student = Student.new(email: 'student1@g.com', name: 'Student1', university: 'NCSU', max_books: 2)
      expect(student).to_not be_valid
    end

    it 'ensures max books is present' do
      student = Student.new(email: 'student1@g.com', name: 'Student1', education: 'Undergraduate', university: 'NCSU')
      expect(student).to_not be_valid
    end



  end

end
