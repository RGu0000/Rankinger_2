# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180301092137) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string "title"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "profile_id"
    t.integer "author_id"
    t.index ["author_id"], name: "index_comments_on_author_id"
    t.index ["profile_id"], name: "index_comments_on_profile_id"
  end

  create_table "league_members", force: :cascade do |t|
    t.integer "user_id"
    t.integer "league_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leagues", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id"
    t.integer "capacity", default: 4, null: false
    t.index ["owner_id"], name: "index_leagues_on_owner_id"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "league_id"
    t.integer "player_1"
    t.integer "player_2"
    t.integer "player1_goals"
    t.integer "player2_goals"
  end

  create_table "rankings", force: :cascade do |t|
    t.integer "league_id", null: false
    t.integer "user_id", null: false
    t.integer "played", default: 0
    t.integer "won", default: 0
    t.integer "drawn", default: 0
    t.integer "lost", default: 0
    t.integer "goals_for", default: 0
    t.integer "goals_against", default: 0
    t.integer "goal_diff", default: 0
    t.integer "points", default: 0
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "rate"
    t.integer "league_id"
    t.integer "user_id"
    t.index ["league_id"], name: "index_ratings_on_league_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
