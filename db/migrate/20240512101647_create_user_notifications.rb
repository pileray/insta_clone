class CreateUserNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :user_notifications do |t|
      t.boolean :read, null: false, default: false
      t.references :notification, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :user_notifications, [:user_id, :notification_id], unique: true
  end
end
