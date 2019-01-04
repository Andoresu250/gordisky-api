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

ActiveRecord::Schema.define(version: 2019_01_02_010127) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "nit"
    t.string "phone"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "loans", force: :cascade do |t|
    t.decimal "amount", precision: 9, scale: 2
    t.decimal "interest", precision: 2, scale: 2
    t.decimal "debt", precision: 9, scale: 2
    t.integer "fees"
    t.integer "fees_fulfilled"
    t.integer "remaining_fees"
    t.integer "frequency"
    t.decimal "paid", precision: 9, scale: 2
    t.date "last_paid"
    t.date "next_paid"
    t.decimal "fee_value", precision: 9, scale: 2
    t.bigint "person_id"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_loans_on_company_id"
    t.index ["person_id"], name: "index_loans_on_person_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "loan_id"
    t.integer "number"
    t.date "date"
    t.date "paid_at"
    t.float "value"
    t.float "paid_value"
    t.string "state", default: "pendiente"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loan_id"], name: "index_payments_on_loan_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "first_names"
    t.string "last_names"
    t.string "identification"
    t.string "phone"
    t.string "address"
    t.float "lat"
    t.float "lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.string "token"
    t.integer "user_id"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.integer "profile_id"
    t.string "profile_type"
    t.string "state", default: "activated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "loans", "companies"
  add_foreign_key "loans", "people"
  add_foreign_key "payments", "loans"
end
