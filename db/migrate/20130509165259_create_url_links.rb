class CreateUrlLinks < ActiveRecord::Migration
  def change
    create_table :url_links do |t|
      t.integer :source_id
      t.string :url
      t.integer :priority, :null=>false, :default=>0
      t.boolean :parsed, :null=>false, :default=>false
    end
  end
end
