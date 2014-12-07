class CreateRssUrls < ActiveRecord::Migration
  def change
    create_table :rss_urls do |t|
      t.integer :source_id, :null=>false
      t.string :url, :null=>false
      t.string :last_processed, :null=>true
    end
  end
end
