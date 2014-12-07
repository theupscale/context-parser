class CreateContexts < ActiveRecord::Migration
  def change
    create_table :contexts do |t|
      t.string  :name
    end
    
    add_index(:contexts,:name,:unique=>true)
  end
end
