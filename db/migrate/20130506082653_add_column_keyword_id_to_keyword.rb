class AddColumnKeywordIdToKeyword < ActiveRecord::Migration
  def change
    add_column :keywords,:keyword_id, :integer, :null=>true
  end
end
