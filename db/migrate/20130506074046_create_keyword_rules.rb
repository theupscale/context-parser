class CreateKeywordRules < ActiveRecord::Migration
  def change
    create_table :keyword_rules do |t|
      t.integer :keyword_id, :null=>false
      t.integer :kewword_context_id, :null=>false
      t.integer :weight,:null=>false,:default=>0
      t.string  :mode,:null=>false
    end
  end
end
