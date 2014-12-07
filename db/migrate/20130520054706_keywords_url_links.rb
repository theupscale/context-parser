class KeywordsUrlLinks < ActiveRecord::Migration
  def change
    create_table :keywords_url_links, :id=>false do |t|
      t.integer :keyword_id, :null=>false
      t.integer :url_link_id, :null=>false
    end
  end
end
