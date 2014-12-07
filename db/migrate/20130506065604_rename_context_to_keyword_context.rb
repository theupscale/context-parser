class RenameContextToKeywordContext < ActiveRecord::Migration
  def change
    rename_table :contexts, :keyword_contexts
  end
end
