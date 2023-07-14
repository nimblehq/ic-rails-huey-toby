# frozen_string_literal: true

Fabricator(:search_result) do
  keyword { Faker::Lorem.word }
  search_engine { SearchResult.search_engines.keys.sample }
  status { SearchResult.statuses.keys.sample }
  user_id { Faker::Number.digit }
end
