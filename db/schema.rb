# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_03_14_013933) do
  create_table "applications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "app_token"
    t.string "app_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "chatCount"
  end

  create_table "chats", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "app_token"
    t.integer "chat_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "messageCount"
  end

  create_table "messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "content"
    t.string "app_token"
    t.integer "chat_number"
    t.integer "message_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
