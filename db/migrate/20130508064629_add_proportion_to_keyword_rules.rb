class AddProportionToKeywordRules < ActiveRecord::Migration
  def change
    add_column :keyword_rules,:proportion ,:integer,:null=>true,:default=>5
  end
end
