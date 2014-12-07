class AddIndexesToDumps < ActiveRecord::Migration
  def change
    add_index(:url_link_dumps, :published_on)
    add_index(:url_links, :published_on)
  end
end
