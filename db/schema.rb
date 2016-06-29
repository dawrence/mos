# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20160420034926) do

  create_table "additionals", :force => true do |t|
    t.integer  "product_id"
    t.integer  "additional_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "quantity",      :default => 0
    t.float    "unit_price",    :default => 0.0
  end

  add_index "additionals", ["additional_id"], :name => "index_additionals_on_additional_id"
  add_index "additionals", ["product_id"], :name => "index_additionals_on_product_id"

  create_table "bills", :force => true do |t|
    t.string   "status"
    t.integer  "table_id"
    t.float    "price"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.text     "note"
    t.integer  "people_quantity"
    t.integer  "discount_voucher_id"
    t.integer  "user_id"
    t.boolean  "updated_mk",          :default => false
    t.string   "payment_type",        :default => "cash"
    t.integer  "billing_number",      :default => 0
    t.string   "client_name"
    t.string   "client_address"
    t.string   "client_phone"
    t.string   "client_email"
    t.float    "tax",                 :default => 0.0
    t.string   "tip_type",            :default => "val"
    t.float    "tip",                 :default => 0.0
    t.float    "discount_value",      :default => 0.0
    t.float    "total",               :default => 0.0
    t.string   "previous_status"
  end

  add_index "bills", ["table_id"], :name => "index_bills_on_table_id"

  create_table "closing_stages", :force => true do |t|
    t.float    "system_sales"
    t.float    "system_expenses"
    t.float    "initial_cash"
    t.float    "physical_total"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.float    "tips_total"
    t.float    "total_discount",  :default => 0.0
  end

  create_table "discount_vouchers", :force => true do |t|
    t.string   "name"
    t.string   "discount_type"
    t.float    "value"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "expenses", :force => true do |t|
    t.text     "description"
    t.float    "value"
    t.string   "receipt_number"
    t.integer  "user_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "counted",        :default => false
  end

  add_index "expenses", ["user_id"], :name => "index_expenses_on_user_id"

  create_table "ingredients", :force => true do |t|
    t.integer  "supply_id"
    t.float    "quantity"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "product_id"
    t.boolean  "modificable",  :default => true
    t.boolean  "quantifiable", :default => false
  end

  add_index "ingredients", ["product_id"], :name => "index_ingredients_on_product_id"
  add_index "ingredients", ["supply_id"], :name => "index_ingredients_on_supply_id"

  create_table "inventory_movements", :force => true do |t|
    t.integer  "supply_id"
    t.string   "movement_type"
    t.float    "quantity"
    t.text     "description"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "adjustment",    :default => false
    t.integer  "user_id"
  end

  add_index "inventory_movements", ["supply_id"], :name => "index_inventory_movements_on_suply_id"

  create_table "kitchens", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "menu_products", :force => true do |t|
    t.string   "name"
    t.integer  "product_family_id"
    t.text     "description"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "additional",        :default => false
    t.boolean  "modificable",       :default => false
  end

  add_index "menu_products", ["product_family_id"], :name => "index_menu_products_on_product_family_id"

  create_table "orders", :force => true do |t|
    t.integer  "bill_id"
    t.boolean  "ship"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "quantity",   :default => 0
    t.integer  "product_id"
    t.float    "unit_price", :default => 0.0
    t.string   "status",     :default => "queue"
  end

  add_index "orders", ["bill_id"], :name => "index_orders_on_bill_id"
  add_index "orders", ["product_id"], :name => "index_orders_on_product_id"

  create_table "privileges", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.integer  "log_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "product_classes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "product_families", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "additional_family", :default => false
    t.integer  "order"
  end

  create_table "product_kitchens", :force => true do |t|
    t.integer  "product_id"
    t.integer  "kitchen_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "products", :force => true do |t|
    t.integer  "menu_product_id"
    t.boolean  "original"
    t.float    "price"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "original_copy",   :default => false
  end

  add_index "products", ["menu_product_id"], :name => "index_products_on_menu_product_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "identifier"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "role_type",   :default => ""
  end

  create_table "settings", :force => true do |t|
    t.string   "nit"
    t.string   "business_name"
    t.string   "address"
    t.string   "city"
    t.string   "telephone"
    t.string   "mail"
    t.string   "prefix"
    t.integer  "lower_range"
    t.integer  "upper_range"
    t.integer  "consumption_tax"
    t.text     "tip_text"
    t.string   "billing_system_resolution"
    t.string   "billing_resolution"
    t.string   "date"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.datetime "cutoff_date",               :default => '2016-04-09 21:31:27'
  end

  create_table "supplies", :force => true do |t|
    t.string   "name"
    t.integer  "supply_category_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "supplies", ["supply_category_id"], :name => "index_supplies_on_supply_category_id"

  create_table "supply_categories", :force => true do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tables", :force => true do |t|
    t.string   "name",        :limit => 3
    t.string   "description"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.boolean  "auxiliar",                 :default => false
  end

  create_table "user_kitchens", :force => true do |t|
    t.integer  "user_id"
    t.integer  "kitchen_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "role",                   :default => 2
    t.string   "name"
    t.string   "status"
    t.string   "id_number"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
