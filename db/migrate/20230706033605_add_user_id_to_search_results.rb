class AddUserIdToSearchResults < ActiveRecord::Migration[7.0]
  def up
    # Add user_id columns
    add_column :search_results,    :user_id, :uuid, null: true

    add_foreign_key :search_results, :users, column: :user_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
