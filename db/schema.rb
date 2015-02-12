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

ActiveRecord::Schema.define(version: 20150212100940) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"
  enable_extension "uuid-ossp"

  create_table "assets", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "file_name",                              null: false
    t.string   "file_basename",                          null: false
    t.string   "file_ext",                               null: false
    t.integer  "file_size",                              null: false
    t.string   "file_mime",                              null: false
    t.string   "assembly_id",                            null: false
    t.string   "assembly_url",                           null: false
    t.float    "upload_duration"
    t.float    "execution_duration"
    t.string   "assembly_message"
    t.json     "file_meta",                 default: {}, null: false
    t.json     "results",                   default: {}, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "site_id",                                null: false
    t.string   "title"
    t.text     "description"
    t.string   "attribution"
    t.integer  "blueprint_id"
    t.string   "blueprint_name"
    t.string   "blueprint_filename"
    t.string   "blueprint_attachable_type"
    t.integer  "blueprint_attachable_id"
    t.integer  "blueprint_position"
    t.string   "blueprint_guid"
    t.string   "blueprint_caption"
    t.string   "blueprint_assoc"
    t.integer  "recording_id"
    t.string   "file_types",                default: [],              array: true
  end

  add_index "assets", ["file_types"], name: "index_assets_on_file_types", using: :btree
  add_index "assets", ["site_id"], name: "index_assets_on_site_id", using: :btree

  create_table "heracles_site_administrations", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "site_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",    null: false
  end

  add_index "heracles_site_administrations", ["site_id"], name: "index_heracles_site_administrations_on_site_id", using: :btree
  add_index "heracles_site_administrations", ["user_id"], name: "index_heracles_site_administrations_on_user_id", using: :btree

  create_table "heracles_users", force: true do |t|
    t.string   "email",                                  null: false
    t.string   "name",                                   null: false
    t.boolean  "superadmin",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "heracles_users", ["email"], name: "index_heracles_users_on_email", unique: true, using: :btree
  add_index "heracles_users", ["reset_password_token"], name: "index_heracles_users_on_reset_password_token", unique: true, using: :btree
  add_index "heracles_users", ["unlock_token"], name: "index_heracles_users_on_unlock_token", unique: true, using: :btree

  create_table "insertions", force: true do |t|
    t.uuid     "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "inserted_key"
    t.string   "field",        null: false
  end

  add_index "insertions", ["field"], name: "index_insertions_on_field", using: :btree
  add_index "insertions", ["inserted_key"], name: "index_insertions_on_inserted_key", using: :btree
  add_index "insertions", ["page_id"], name: "index_insertions_on_page_id", using: :btree

  create_table "page_cache_checks", force: true do |t|
    t.string   "edge_url",   null: false
    t.string   "checksum"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_cache_checks", ["edge_url"], name: "index_page_cache_checks_on_edge_url", unique: true, using: :btree

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
    t.string   "insertion_key",                  null: false
    t.string   "page_type",                      null: false
  end

  add_index "pages", ["ancestry"], name: "index_pages_on_ancestry", using: :btree
  add_index "pages", ["collection_id"], name: "index_pages_on_collection_id", using: :btree
  add_index "pages", ["hidden"], name: "index_pages_on_hidden", using: :btree
  add_index "pages", ["insertion_key"], name: "index_pages_on_insertion_key", using: :btree
  add_index "pages", ["page_type"], name: "index_pages_on_page_type", using: :btree
  add_index "pages", ["published"], name: "index_pages_on_published", using: :btree
  add_index "pages", ["site_id"], name: "index_pages_on_site_id", using: :btree
  add_index "pages", ["type"], name: "index_pages_on_type", using: :btree
  add_index "pages", ["url"], name: "index_pages_on_url", using: :btree

  create_table "que_jobs", primary_key: "queue", force: true do |t|
    t.integer  "priority",    limit: 2, default: 100,                                        null: false
    t.datetime "run_at",                default: "now()",                                    null: false
    t.integer  "job_id",      limit: 8, default: "nextval('que_jobs_job_id_seq'::regclass)", null: false
    t.text     "job_class",                                                                  null: false
    t.json     "args",                  default: [],                                         null: false
    t.integer  "error_count",           default: 0,                                          null: false
    t.text     "last_error"
  end

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

  create_table "site_administrations", id: false, force: true do |t|
    t.uuid     "id",         default: "uuid_generate_v4()", null: false
    t.uuid     "site_id",                                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                                   null: false
  end

  add_index "site_administrations", ["site_id"], name: "index_site_administrations_on_site_id", using: :btree
  add_index "site_administrations", ["user_id"], name: "index_site_administrations_on_user_id", using: :btree

  create_table "sites", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "title"
    t.string   "origin_hostnames",   default: [],                 array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.boolean  "published",          default: false
    t.json     "transloadit_params", default: {},    null: false
    t.string   "preview_token",                      null: false
    t.string   "edge_hostnames",     default: [],                 array: true
  end

  add_index "sites", ["edge_hostnames"], name: "index_sites_on_edge_hostnames", using: :btree
  add_index "sites", ["origin_hostnames"], name: "index_sites_on_origin_hostnames", using: :gin
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
    t.string  "slug",                       null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree
  add_index "tags", ["slug"], name: "index_tags_on_slug", using: :btree

  create_table "users", force: true do |t|
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
