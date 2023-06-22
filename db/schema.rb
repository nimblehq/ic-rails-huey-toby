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

ActiveRecord::Schema.define(version: 2023_06_14_085953) do

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

end
