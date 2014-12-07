class RemoveContextIdFromCategory < ActiveRecord::Migration
  def change
    remove_column :categories, :context_id
  end
end
