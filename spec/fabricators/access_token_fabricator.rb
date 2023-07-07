# frozen_string_literal: true

Fabricator(:access_token, from: 'Doorkeeper::AccessToken') do
  token { Faker::Crypto.md5 }
  expires_in { Faker::Number.non_zero_digit.hours }
  scopes { 'public' } # The default scopes is always public
end
