class CreatePersonalities < ActiveRecord::Migration[7.0]
  def change
    create_table :personalities do |t|
      t.string :mood
      t.string :answer
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
