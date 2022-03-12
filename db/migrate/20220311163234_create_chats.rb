class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.string :app_token
      t.integer :chat_number
      t.timestamps
    end
  end
end
