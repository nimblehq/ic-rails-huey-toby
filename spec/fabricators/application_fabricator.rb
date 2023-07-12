# frozen_string_literal: true

Fabricator(:application, from: 'Doorkeeper::Application') do
  name { Faker::App.name }
  uid { 'client_id' }
  secret { 'client_secret' }
  redirect_uri { Faker::Internet.url(scheme: 'https') }
end
