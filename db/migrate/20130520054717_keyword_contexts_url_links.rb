class KeywordContextsUrlLinks < ActiveRecord::Migration
  def change
    create_table :keyword_contexts_url_links, :id=>false do |t|
      t.integer :keyword_context_id, :null=>false
      t.integer :url_link_id, :null=>false
    end
  end
end
