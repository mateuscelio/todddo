class AddNotificationSettingsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :notification_settings, :json
  end
end
