class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :content
      t.string :app_token
      t.integer :chat_number
      t.integer :message_number
      t.timestamps
    end
  end
end
