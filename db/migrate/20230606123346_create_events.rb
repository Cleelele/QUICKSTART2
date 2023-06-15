class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :image
      t.string :category
      t.string :address
      t.string :description
      t.integer :price

      t.timestamps
    end
  end
end
