class AddMessageCountToChats < ActiveRecord::Migration[7.0]
  def change
    add_column :chats, :messageCount, :integer
  end
end
