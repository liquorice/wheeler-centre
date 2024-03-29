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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141015044644) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "assets", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "file_name",                       null: false
    t.string   "file_basename",                   null: false
    t.string   "file_ext",                        null: false
    t.integer  "file_size",                       null: false
    t.string   "file_mime",                       null: false
    t.string   "file_type"
    t.string   "assembly_id",                     null: false
    t.string   "assembly_url",                    null: false
    t.float    "upload_duration"
    t.float    "execution_duration"
    t.string   "assembly_message"
    t.json     "file_meta",          default: {}, null: false
    t.json     "results",            default: {}, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "site_id",                         null: false
    t.string   "title"
    t.text     "description"
    t.string   "attribution"
  end

  add_index "assets", ["file_type"], name: "index_assets_on_file_type", using: :btree
  add_index "assets", ["site_id"], name: "index_assets_on_site_id", using: :btree

  create_table "insertions", force: true do |t|
    t.uuid     "page_id"
    t.uuid     "insertable_id"
    t.string   "insertable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "insertions", ["insertable_id", "insertable_type"], name: "index_insertions_on_insertable_id_and_insertable_type", using: :btree
  add_index "insertions", ["page_id"], name: "index_insertions_on_page_id", using: :btree

  create_table "pages", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "slug",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",                          null: false
    t.json     "fields_data",    default: {},    null: false
    t.uuid     "site_id",                        null: false
    t.string   "ancestry"
    t.text     "url"
    t.string   "type"
    t.string   "template"
    t.integer  "page_order",                     null: false
    t.uuid     "collection_id"
    t.boolean  "published",      default: false, null: false
    t.boolean  "hidden",         default: false, null: false
    t.boolean  "locked",         default: false, null: false
    t.integer  "ancestry_depth", default: 0
  end

  add_index "pages", ["ancestry"], name: "index_pages_on_ancestry", using: :btree
  add_index "pages", ["collection_id"], name: "index_pages_on_collection_id", using: :btree
  add_index "pages", ["hidden"], name: "index_pages_on_hidden", using: :btree
  add_index "pages", ["published"], name: "index_pages_on_published", using: :btree
  add_index "pages", ["site_id"], name: "index_pages_on_site_id", using: :btree
  add_index "pages", ["type"], name: "index_pages_on_type", using: :btree
  add_index "pages", ["url"], name: "index_pages_on_url", using: :btree

  create_table "redirects", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "site_id",        null: false
    t.string   "source_url",     null: false
    t.string   "target_url"
    t.integer  "redirect_order", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "redirects", ["site_id", "source_url"], name: "index_redirects_on_site_id_and_source_url", using: :btree
  add_index "redirects", ["site_id"], name: "index_redirects_on_site_id", using: :btree

  create_table "site_administrations", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "user_id",    null: false
    t.uuid     "site_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "site_administrations", ["site_id"], name: "index_site_administrations_on_site_id", using: :btree
  add_index "site_administrations", ["user_id"], name: "index_site_administrations_on_user_id", using: :btree

  create_table "sites", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "title"
    t.string   "hostnames",          default: [],                 array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.boolean  "published",          default: false
    t.json     "transloadit_params", default: {},    null: false
    t.string   "preview_token",                      null: false
  end

  add_index "sites", ["hostnames"], name: "index_sites_on_hostnames", using: :gin
  add_index "sites", ["published"], name: "index_sites_on_published", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.uuid     "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "superadmin",             default: false, null: false
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
