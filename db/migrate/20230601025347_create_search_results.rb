class CreateSearchResults < ActiveRecord::Migration[7.0]
  def change
    create_table :search_results do |t|
      t.string :keyword
      t.integer :status
      t.integer :adwords_top_count
      t.integer :adwords_total_count
      t.text :adwords_top_urls
      t.integer :non_adwords_count
      t.text :non_adwords_urls
      t.integer :total_links_count
      t.text :html_code
      t.string :search_engine

      t.timestamps
    end
  end
end
