# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(username: "yamasou", email: "s.yama@ashita-team.com", password: "password", password_confirmation: "password")
User.create(username: "山口", email: "guti@guti", password: "password", password_confirmation: "password")

label_names = ["業務報告", "経費計算", "資料作成", "その他"]
label_names.each do |name|
  Label.create(name: name)
end
