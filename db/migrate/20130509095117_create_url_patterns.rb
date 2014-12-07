class CreateUrlPatterns < ActiveRecord::Migration
  def change
    create_table :url_patterns do |t|
      t.integer :source_id
      t.string :pattern
      t.string :content_xpath
      t.string :page_type
    end
  end
end
