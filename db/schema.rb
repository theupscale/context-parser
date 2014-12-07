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

ActiveRecord::Schema.define(:version => 20130913044021) do

  create_table "categories", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "categories", ["name"], :name => "index_categories_on_name", :unique => true

  create_table "keyword_contexts", :force => true do |t|
    t.string  "name"
    t.integer "weight",      :default => 5,    :null => false
    t.boolean "is_relevant", :default => true, :null => false
  end

  add_index "keyword_contexts", ["name"], :name => "index_contexts_on_name", :unique => true

  create_table "keyword_contexts_url_links", :id => false, :force => true do |t|
    t.integer "keyword_context_id", :null => false
    t.integer "url_link_id",        :null => false
  end

  create_table "keyword_rules", :force => true do |t|
    t.integer "keyword_id",                        :null => false
    t.integer "keyword_context_id",                :null => false
    t.integer "weight",             :default => 0, :null => false
    t.string  "mode",                              :null => false
    t.integer "proportion",         :default => 5
  end

  create_table "keywords", :force => true do |t|
    t.string  "name",                          :null => false
    t.integer "category_id",                   :null => false
    t.integer "keyword_id"
    t.boolean "visible",     :default => true, :null => false
  end

  add_index "keywords", ["name"], :name => "index_keywords_on_name", :unique => true

  create_table "keywords_url_links", :id => false, :force => true do |t|
    t.integer "keyword_id",  :null => false
    t.integer "url_link_id", :null => false
  end

  create_table "rss_urls", :force => true do |t|
    t.integer "source_id",      :null => false
    t.string  "url",            :null => false
    t.string  "last_processed"
  end

  create_table "sources", :force => true do |t|
    t.string "domain_name",                                                          :null => false
    t.string "base_url",                                                             :null => false
    t.string "search_url",                                                           :null => false
    t.string "generic_pattern", :default => "//body",                                :null => false
    t.string "country",         :default => "INDIA",                                 :null => false
    t.string "name",            :default => "SOURCE",                                :null => false
    t.string "image_xpath",     :default => "//meta[@property='og:image']/@content"
  end

  create_table "url_contexts", :force => true do |t|
    t.integer "keyword_context_id", :null => false
    t.integer "url_link_id",        :null => false
    t.float   "score",              :null => false
  end

  create_table "url_keywords", :force => true do |t|
    t.integer "keyword_id",  :null => false
    t.integer "url_link_id", :null => false
    t.float   "score",       :null => false
  end

  create_table "url_link_dumps", :force => true do |t|
    t.integer  "source_id"
    t.string   "url"
    t.string   "etag",                            :null => false
    t.datetime "published_on"
    t.string   "title"
    t.string   "description"
    t.boolean  "processed",    :default => false, :null => false
  end

  add_index "url_link_dumps", ["etag", "source_id"], :name => "index_url_link_dumps_on_etag_and_source_id", :unique => true
  add_index "url_link_dumps", ["published_on"], :name => "index_url_link_dumps_on_published_on"

  create_table "url_links", :force => true do |t|
    t.integer  "source_id"
    t.string   "url"
    t.integer  "priority",        :default => 0,     :null => false
    t.boolean  "parsed",          :default => false, :null => false
    t.datetime "published_on"
    t.string   "title",                              :null => false
    t.text     "description"
    t.string   "image_url"
    t.float    "relevancy_score", :default => 0.0,   :null => false
    t.string   "etag",                               :null => false
  end

  add_index "url_links", ["published_on"], :name => "index_url_links_on_published_on"

  create_table "url_patterns", :force => true do |t|
    t.integer "source_id"
    t.string  "pattern"
    t.string  "content_xpath"
    t.string  "page_type"
  end

end
