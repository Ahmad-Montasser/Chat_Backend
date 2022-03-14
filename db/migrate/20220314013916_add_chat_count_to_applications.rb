class AddChatCountToApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :applications, :chatCount, :integer
  end
end
