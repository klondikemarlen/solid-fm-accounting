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

ActiveRecord::Schema[8.0].define(version: 2026_07_18_134032) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.string "account_type", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_accounts_on_user_id_and_name", unique: true, where: "(deleted_at IS NULL)"
    t.check_constraint "account_type::text = ANY (ARRAY['cash'::character varying, 'chequing'::character varying, 'savings'::character varying, 'credit_card'::character varying]::text[])", name: "accounts_account_type"
    t.check_constraint "btrim(name::text) <> ''::text", name: "accounts_name_present"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.string "transaction_type", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_categories_on_code", unique: true, where: "(deleted_at IS NULL)"
    t.index ["name"], name: "index_categories_on_name", unique: true, where: "(deleted_at IS NULL)"
    t.check_constraint "btrim(code::text) <> ''::text AND btrim(name::text) <> ''::text", name: "categories_code_and_name_present"
    t.check_constraint "transaction_type::text = ANY (ARRAY['income'::character varying, 'expense'::character varying, 'both'::character varying]::text[])", name: "categories_transaction_type"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_payment_methods_on_name", unique: true, where: "(deleted_at IS NULL)"
    t.check_constraint "btrim(name::text) <> ''::text", name: "payment_methods_name_present"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.bigint "payment_method_id", null: false
    t.bigint "account_id", null: false
    t.string "transaction_type", null: false
    t.date "transaction_date", null: false
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.string "vendor"
    t.text "description"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["payment_method_id"], name: "index_transactions_on_payment_method_id"
    t.index ["user_id", "transaction_date"], name: "index_transactions_on_user_id_and_transaction_date"
    t.check_constraint "amount > 0::numeric", name: "transactions_amount_positive"
    t.check_constraint "transaction_type::text = ANY (ARRAY['income'::character varying, 'expense'::character varying]::text[])", name: "transactions_transaction_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name"
    t.string "display_name", null: false
    t.string "auth0_subject", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["auth0_subject"], name: "index_users_on_auth0_subject_unique", unique: true, where: "(deleted_at IS NULL)"
    t.index ["email"], name: "index_users_on_email_unique", unique: true, where: "(deleted_at IS NULL)"
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "categories"
  add_foreign_key "transactions", "payment_methods"
  add_foreign_key "transactions", "users"
end
