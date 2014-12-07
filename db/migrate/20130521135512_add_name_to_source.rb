class AddNameToSource < ActiveRecord::Migration
  def change
    add_column :sources, :name, :string, :null=>false,:default=>"SOURCE"
  end
end
