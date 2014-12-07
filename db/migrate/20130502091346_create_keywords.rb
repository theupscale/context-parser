class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :name, :null=>false
      t.integer :weight, :null=>false
      t.integer :category_id, :null=>false
    end
    
    add_index(:keywords,:name,:unique=>true)
  end
end
