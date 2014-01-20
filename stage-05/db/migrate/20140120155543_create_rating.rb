class CreateRating < ActiveRecord::Migration

  def change

    create_table :ratings do |t|
      t.integer :compliment_id
      t.integer :stars
      t.timestamps
    end

    # Always add a database index for foreign keys to improve lookup speed.
    add_index :ratings, :compliment_id

  end

end
