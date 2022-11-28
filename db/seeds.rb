# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

library = Library.create([{name: 'Hunt', university: 'NC State', location: 'Centennial Campus',
                           max_days: 10, fines: 3 }, {name: 'D. H. Hill', university: 'NC State', location: 'Main Campus',
                                            max_days: 10, fines: 5 }])

admin = User.new({email:"admin@admin.com", password:"admin",password_confirmation:"admin",role:2})
admin.save
admin2 = Admin.new({email:"admin@admin.com", password:"admin",name:"Default Seeded Admin"})
admin2.save
