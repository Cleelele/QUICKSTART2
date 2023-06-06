class CreateQuestionnaires < ActiveRecord::Migration[7.0]
  def change
    create_table :questionnaires do |t|
      t.string :questions
      t.string :results
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
