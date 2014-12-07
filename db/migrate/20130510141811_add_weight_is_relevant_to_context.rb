class AddWeightIsRelevantToContext < ActiveRecord::Migration
  def change
    add_column :keyword_contexts, :weight, :integer, :null=>false,:default=>5
    add_column :keyword_contexts, :is_relevant, :boolean, :null=>false, :default=>true
  end
end
