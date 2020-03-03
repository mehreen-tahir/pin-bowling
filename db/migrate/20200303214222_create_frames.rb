class CreateFrames < ActiveRecord::Migration[6.0]
  def change
    create_table :frames do |t|
      t.integer :game_id

      t.integer :number, default: 1
      t.integer :score, default: 0
      t.integer :first_roll
      t.integer :second_roll

      t.timestamps
    end
  end
end
