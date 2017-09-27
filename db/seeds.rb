# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

roles = Role.create([{ role: 'admin', description: 'Has all rights' }, { role: 'user', description: 'Has user rights' }])
user = User.create([{ name: 'Medale Femi', password: 'admin', email: 'admin@gmail.com', role_id: roles.first.id },
                    { name: 'Ayodeji Femi', password: 'user', email: 'user@gmail.com', role_id: roles.first.id + 1 }])
