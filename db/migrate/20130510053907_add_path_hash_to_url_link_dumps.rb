class AddPathHashToUrlLinkDumps < ActiveRecord::Migration
  def change
    add_column :url_link_dumps, :etag, :string, :null=>false
    add_index :url_link_dumps,[:etag,:source_id],:unique=>true
  end
end
