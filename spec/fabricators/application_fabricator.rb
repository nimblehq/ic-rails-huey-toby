# frozen_string_literal: true

Fabricator(:application, from: 'Doorkeeper::Application') do
  name { Faker::App.name }
  redirect_uri { Faker::Internet.url(scheme: 'https') }
end
