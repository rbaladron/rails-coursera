# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Person.destroy_all

Person.create! [
  { first_name: "Kalman", last_name: "Smith", age: 33, login: "kman", pass: "abc123" },
  { first_name: "John", last_name: "Whatever", age: 27, login: "john1", pass: "123abc" },
  { first_name: "Michael", last_name: "Smith", age: 15, login: "mike", pass: "not_telling" },
  { first_name: "Josh", last_name: "Oreck", age: 57, login: "josh", pass: "password1" },
  { first_name: "John", last_name: "Smith", age: 27, login: "john2", pass: "no_idea" },
  { first_name: "Bill", last_name: "Gates", age: 75, login: "bill", pass: "windows3.1" },
  { first_name: "LeBron", last_name: "James", age: 30, login: "bron", pass: "need more rings" }
]

Person.find_by!(first_name: "Kalman").create_personal_info(height: 6.0, weight: 210)
Person.find_by!(first_name: "John", last_name: "Whatever").create_personal_info(height: 5.3, weight: 175)
Person.find_by!(first_name: "Michael").create_personal_info(height: 5.5, weight: 200)
Person.find_by!(first_name: "Josh").create_personal_info(height: 6.5, weight: 235)
Person.find_by!(first_name: "John", last_name: "Smith").create_personal_info(height: 6.0, weight: 210)
Person.find_by!(first_name: "Bill").create_personal_info(height: 6.1, weight: 199)
Person.find_by!(first_name: "LeBron").create_personal_info(height: 7.0, weight: 250)
