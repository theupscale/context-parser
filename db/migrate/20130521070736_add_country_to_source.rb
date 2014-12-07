class AddCountryToSource < ActiveRecord::Migration
  def change
    add_column :sources, :country, :string, :null=>false, :default=>"INDIA"
  end
end
