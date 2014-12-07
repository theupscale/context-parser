class RemoveWeightFromKeywordCategory < ActiveRecord::Migration
  def change
    remove_column :categories, :weight
    remove_column :keywords, :weight
  end
end
