# frozen_string_literal: true

Fabricator(:user) do
  id { Faker::Number.digit }
  provider { Faker::Omniauth.google[:provider] }
  provider_uid { Faker::Omniauth.google[:uid] }
  email { Faker::Internet.email }
  password { Faker::Internet.password }
  full_name { Faker::Name.name }
  avatar_url { Faker::Avatar.image }
end
