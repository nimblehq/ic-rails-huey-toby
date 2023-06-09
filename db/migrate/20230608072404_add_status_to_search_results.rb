class AddStatusToSearchResults < ActiveRecord::Migration[7.0]
  def change
    add_column :search_results, :status, :string, default: 'in_progress'
  end
end
