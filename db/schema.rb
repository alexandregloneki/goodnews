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

ActiveRecord::Schema.define(:version => 20121108230219) do

  create_table "accounts", :force => true do |t|
    t.integer  "status_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "user_id"
    t.string   "token_access"
  end

  add_index "accounts", ["status_id"], :name => "index_accounts_on_status_id"

  create_table "admins", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "emailnotifications", :force => true do |t|
    t.integer  "email_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "notification_id"
  end

  add_index "emailnotifications", ["email_id"], :name => "index_emailnotifications_on_email_id"

  create_table "emails", :force => true do |t|
    t.string   "title"
    t.string   "to"
    t.string   "cc"
    t.string   "cco"
    t.integer  "status_id"
    t.text     "message"
    t.integer  "workflow_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "account_id"
  end

  add_index "emails", ["status_id"], :name => "index_emails_on_status_id"
  add_index "emails", ["workflow_id"], :name => "index_emails_on_workflow_id"

  create_table "notifications", :force => true do |t|
    t.integer  "workflow_id"
    t.integer  "account_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "notifications", ["account_id"], :name => "index_notifications_on_account_id"
  add_index "notifications", ["workflow_id"], :name => "index_notifications_on_workflow_id"

  create_table "operators", :force => true do |t|
    t.string   "name"
    t.string   "simbol"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "account_id"
    t.integer  "plan_id"
    t.integer  "status_id"
    t.text     "observacao"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "orders", ["account_id"], :name => "index_orders_on_account_id"
  add_index "orders", ["plan_id"], :name => "index_orders_on_plan_id"
  add_index "orders", ["status_id"], :name => "index_orders_on_status_id"

  create_table "payments", :force => true do |t|
    t.string   "name"
    t.integer  "status_id"
    t.string   "imagem"
    t.string   "codigo_integracao"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "payments", ["status_id"], :name => "index_payments_on_status_id"

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.float    "value"
    t.integer  "status_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "description"
  end

  add_index "plans", ["status_id"], :name => "index_plans_on_status_id"

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "rules", :force => true do |t|
    t.string   "field_references"
    t.string   "field_comparation"
    t.string   "value_comparation"
    t.integer  "operator_id"
    t.integer  "workflow_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "name"
    t.integer  "type_field_id"
  end

  add_index "rules", ["operator_id"], :name => "index_rules_on_operator_id"
  add_index "rules", ["workflow_id"], :name => "index_rules_on_workflow_id"

  create_table "sendmails", :force => true do |t|
    t.integer  "workflow_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "email_id"
  end

  add_index "sendmails", ["workflow_id"], :name => "index_sendmails_on_workflow_id"

  create_table "sendsms", :force => true do |t|
    t.integer  "sm_id"
    t.integer  "workflow_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "sendsms", ["sm_id"], :name => "index_sendsms_on_sm_id"
  add_index "sendsms", ["workflow_id"], :name => "index_sendsms_on_workflow_id"

  create_table "sms", :force => true do |t|
    t.string   "number_dispatch"
    t.string   "name_sender"
    t.text     "message"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "name"
    t.integer  "status_id"
    t.integer  "account_id"
  end

  create_table "smsnotifications", :force => true do |t|
    t.integer  "sm_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "notification_id"
  end

  add_index "smsnotifications", ["sm_id"], :name => "index_smsnotifications_on_sm_id"

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.string   "color"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "type_fields", :force => true do |t|
    t.string   "name"
    t.string   "key"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "simbol"
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
    t.string   "city"
    t.string   "state"
    t.string   "neighbord"
    t.string   "street"
    t.string   "number_street"
    t.string   "phone"
    t.string   "postal_code"
    t.string   "country"
    t.string   "name"
    t.string   "second_name"
    t.string   "user_document"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "workflows", :force => true do |t|
    t.string   "name"
    t.integer  "status_id"
    t.date     "date_start"
    t.date     "date_finish"
    t.integer  "account_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "workflows", ["account_id"], :name => "index_workflows_on_account_id"
  add_index "workflows", ["status_id"], :name => "index_workflows_on_status_id"

end
