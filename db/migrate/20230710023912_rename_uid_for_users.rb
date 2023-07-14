class RenameUidForUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :uid, :provider_uid
  end
end
