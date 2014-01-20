class CreateCompliment < ActiveRecord::Migration

  def change
    create_table :compliments do |t|
      t.string :message
      t.timestamps
    end
  end

end
