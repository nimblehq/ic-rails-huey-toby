class AddParseResultsToSearchResult < ActiveRecord::Migration[7.0]
  def change
      add_column :search_results, :adwords_top_count, :integer
      add_column :search_results, :adwords_total_count, :integer
      add_column :search_results, :adwords_top_urls, :string, array: true
      add_column :search_results, :non_adwords_count, :integer
      add_column :search_results, :non_adwords_urls, :string, array: true
      add_column :search_results, :total_links_count, :integer
  end
end
