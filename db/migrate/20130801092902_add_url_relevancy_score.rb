class AddUrlRelevancyScore < ActiveRecord::Migration
  def change
    add_column :url_links, :relevancy_score, :float, :null=>false, :default=>0
  end
end
