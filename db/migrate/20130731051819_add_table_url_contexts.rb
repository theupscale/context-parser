class AddTableUrlContexts < ActiveRecord::Migration
  def change
    create_table :url_contexts do |t|
      t.integer :keyword_context_id, :null=>false
      t.integer :url_link_id, :null=>false
      t.float :score, :null=>false
    end
  end
end
