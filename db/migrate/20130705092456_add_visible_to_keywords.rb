class AddVisibleToKeywords < ActiveRecord::Migration
  def change
    add_column :keywords,:visible, :boolean, :null=>false, :default=>true
  end
end
