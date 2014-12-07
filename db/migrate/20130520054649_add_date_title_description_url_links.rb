class AddDateTitleDescriptionUrlLinks < ActiveRecord::Migration
  def change
    add_column :url_links, :published_on, :datetime, :null=>true
    add_column :url_links, :title, :string, :null=>false
    add_column :url_links, :description, :text, :null=>true
  end
end
