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

ActiveRecord::Schema[8.0].define(version: 2025_10_22_185005) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string "client_name"
    t.string "client_address"
    t.string "client_email"
    t.string "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "company_name"
    t.string "company_info"
    t.string "company_address"
    t.text "bank_details"
    t.integer "vat_number"
    t.integer "tax_number"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "invoice_number"
    t.integer "invoice_status"
    t.date "issue_date"
    t.date "due_date"
    t.text "message"
    t.integer "tax"
    t.integer "total_amount"
    t.bigint "company_id", null: false
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["company_id"], name: "index_invoices_on_company_id"
  end

  create_table "money_transaction_tags", force: :cascade do |t|
    t.bigint "money_transaction_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["money_transaction_id", "tag_id"], name: "idx_on_money_transaction_id_tag_id_226f103e22", unique: true
    t.index ["money_transaction_id"], name: "index_money_transaction_tags_on_money_transaction_id"
    t.index ["tag_id"], name: "index_money_transaction_tags_on_tag_id"
  end

  create_table "money_transactions", force: :cascade do |t|
    t.string "external_id"
    t.date "date"
    t.text "description"
    t.integer "amount_cents", default: 0
    t.string "currency", default: "EUR"
    t.string "direction"
    t.string "source_file"
    t.string "raw_tags"
    t.string "elster_bucket"
    t.boolean "is_business"
    t.boolean "receipt", default: false
    t.boolean "eigenbeleg", default: false
    t.boolean "reviewed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deductible"
    t.boolean "reimbursed"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "companies", "users"
  add_foreign_key "invoices", "clients"
  add_foreign_key "invoices", "companies"
  add_foreign_key "money_transaction_tags", "money_transactions"
  add_foreign_key "money_transaction_tags", "tags"
end
