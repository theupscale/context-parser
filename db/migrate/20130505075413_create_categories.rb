class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, :null=>false
      t.integer :weight,:null=>false
      t.integer :context_id, :null=>false
    end
    add_index(:categories,:name,:unique=>true)
  end
end
