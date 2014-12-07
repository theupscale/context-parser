class AddEtagToLinks < ActiveRecord::Migration
  def change
    add_column :url_links, :etag, :string,:null=>false,:defualt=>"etag"
    UrlLink.all.each {|u| u.save}
  end
end
