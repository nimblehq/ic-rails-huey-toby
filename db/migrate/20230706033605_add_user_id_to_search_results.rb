class AddUserIdToSearchResults < ActiveRecord::Migration[7.0]
  def up
    add_reference :search_results, :user, type: :uuid, foreign_key: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
