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

ActiveRecord::Schema.define(version: 2023_06_26_042619) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "search_results", force: :cascade do |t|
    t.string "keyword"
    t.string "search_engine"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "html_code"
    t.string "status", default: "in_progress"
    t.integer "adwords_top_count"
    t.integer "adwords_total_count"
    t.string "adwords_top_urls", array: true
    t.integer "non_adwords_count"
    t.string "non_adwords_urls", array: true
    t.integer "total_links_count"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "full_name"
    t.string "uid"
    t.string "avatar_url"
    t.string "provider"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
