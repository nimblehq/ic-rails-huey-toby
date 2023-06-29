# frozen_string_literal: true

Fabricator(:user) do
  id { 1 }
  provider { 'google_oauth2' }
  uid { '100000000000000000000' }
  email { 'john@example.com' }
  password { 'password' }
  full_name { 'John Smith' }
  avatar_url { 'https://lh4.googleusercontent.com/photo.jpg' }
end
