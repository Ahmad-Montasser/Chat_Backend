class CreateApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :applications do |t|
      t.string :app_token
      t.string :app_name
      t.timestamps
    end
  end
end
