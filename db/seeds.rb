# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

case Rails.env
when "production"
  redirect_uri = "https://ic-rails-huey-toby.herokuapp.com/api/v1/users/auth/google_oauth2/callback"
  uid = "3QcvmWx7XECsXHJfG6ZEHuRWrKDRBImpQseehRG5AvXO39yBARDEBXZc0IxfaPSu"
  secret = "QZxBAkPMrLma2y7tP3CFqzdYbaTMtRK6aTCW37CplyDhjiviSxEnlpRfsUKE09cR"
when "staging"
 redirect_uri = "https://ic-rails-huey-toby-staging.herokuapp.com/api/v1/users/auth/google_oauth2/callback"
 uid = "VOqMMBc237WmiNkEUh6dx4EvOU8cJjiiy0uKraJJX4e5L51eVlnrbtoVozbAInvc"
 secret = "1RuVgBFgU24MTp2ZUYriT0m7I0CaLNE3BvPRRhDMfSYBsYt6x3la6POHEp6WwtQ2"
when "development"
  redirect_uri  = "https://localhost:3000/api/v1/users/auth/google_oauth2/callback"
  uid = "MouWUcR81F7QDdgzwVlvSqonftQ8H1iszHJqoiuSUnJVvN0eCjTO9dbZJmKPUXlb"
  secret = "MA4gWSjuDF1mcZ60l2NqC7YC86h1jRDEvjnq13QN09hwWXSsJzT6ZYv5mZMNnQcO"
end

if Doorkeeper::Application.count.zero?
    Doorkeeper::Application.create(name: 'ic-rails-huey-toby-client', redirect_uri: redirect_uri, uid: uid, secret: secret)
end