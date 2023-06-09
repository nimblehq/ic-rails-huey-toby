class AddHtmlCodeToSearchResult < ActiveRecord::Migration[7.0]
  def change
    add_column :search_results, :html_code, :text
  end
end
