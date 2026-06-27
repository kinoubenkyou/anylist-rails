class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.belongs_to :list, null: false, foreign_key: true
      t.string :value
      t.string :description

      t.timestamps
    end
  end
end
