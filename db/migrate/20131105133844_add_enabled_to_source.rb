class AddEnabledToSource < ActiveRecord::Migration
  def change
  	add_column :sources, :enabled,:boolean, :null=>false,:default=>true
  end
end
