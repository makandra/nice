class CreateRating < ActiveRecord::Migration

  def change

    create_table :ratings do |t|
      t.integer :compliment_id
      t.integer :stars
      t.timestamps
    end

  end

end
