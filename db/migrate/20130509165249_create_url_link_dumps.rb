class CreateUrlLinkDumps < ActiveRecord::Migration
  def change
    create_table :url_link_dumps do |t|
      t.integer :source_id
      t.string :url
    end
  end
end
