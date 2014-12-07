class RenameKewwToKeywordInRules < ActiveRecord::Migration
  def change
    rename_column :keyword_rules, :kewword_context_id, :keyword_context_id
  end
end
