# frozen_string_literal: true

Fabricator(:user) do
  id { Faker::Number.digit }
  provider { Faker::Omniauth.google[:provider] }
  provider_uid { Faker::Omniauth.google[:uid] }
  email { Faker::Internet.email }
  password { Faker::Internet.password }
  full_name { Faker::Name.name }
  avatar_url { Faker::Avatar.image }
  confirmed_at { Time.current }
  confirmation_sent_at { Time.current }
end
