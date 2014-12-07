class AddProcessedToUrlLinkDumps < ActiveRecord::Migration
  def change
    add_column :url_link_dumps, :processed, :boolean, :null=>false,:default=>false
  end
end
