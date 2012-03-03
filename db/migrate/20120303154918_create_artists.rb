class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :hash_id, :null=>false
      t.string :group_name, :null=>false

      t.timestamps
    end
  end
end
