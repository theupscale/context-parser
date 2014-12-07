class AddImageXpathToSource < ActiveRecord::Migration
  def change
    add_column :sources, :image_xpath, :string, :null=>true, :default=>"//meta[@property='og:image']/@content"
  end
end
