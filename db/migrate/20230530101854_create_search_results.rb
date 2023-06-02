class CreateSearchResults < ActiveRecord::Migration[7.0]
  def change
    create_table :search_results do |t|
      t.string :keyword
      t.integer :search_engine

      t.timestamps
    end
  end
end
