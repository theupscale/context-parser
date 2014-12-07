class AddImageFieldToUrlLinks < ActiveRecord::Migration
  def change
    add_column :url_links,:image_url, :string, :null=>true
  end
end
