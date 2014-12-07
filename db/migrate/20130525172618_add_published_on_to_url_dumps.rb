class AddPublishedOnToUrlDumps < ActiveRecord::Migration
  def change
    add_column :url_link_dumps, :published_on, :datetime, :null=>true
    add_column :url_link_dumps, :title, :string, :null=>true
    add_column :url_link_dumps, :description, :string, :null=>true
  end
end
