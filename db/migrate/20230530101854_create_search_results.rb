class CreateSearchResults < ActiveRecord::Migration[7.0]
  def change
    create_table :search_results do |t|
      t.string :keyword
      t.string :search_engine
      t.text :html_code

      t.timestamps
    end
  end
end
