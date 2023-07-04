class UpdateIdUsers < ActiveRecord::Migration[7.0]
  def up
    # Add UUID columns
    add_column :users,    :uuid, :uuid, null: false, default: -> { "gen_random_uuid()" }

    change_table :users do |t|
      t.remove :id
      t.rename :uuid, :id
    end
    execute "ALTER TABLE users ADD PRIMARY KEY (id);" # Re-add primary key
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
