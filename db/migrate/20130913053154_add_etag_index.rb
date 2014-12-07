class AddEtagIndex < ActiveRecord::Migration
  def change
    add_index :url_links, :etag,:unique=>true
  end
end
