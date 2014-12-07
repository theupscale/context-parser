class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :domain_name,:null=>false
      t.string :base_url,:null=>false
      t.string :search_url,:null=>false
      t.string :generic_pattern, :null=>false,:default=>"//body"
    end
  end
end
