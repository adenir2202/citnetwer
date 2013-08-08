class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text :code, limit: 32760, null: false, default: '#'
      t.string :name, limite: 64, null: false, default: "evt1"
      t.text :argument, limit: 32760
      t.text :answer, limit: 32760
      t.integer :answerType, limit: 1, null: false, defaul: 1
      t.integer :language, limit: 1, null: false, default: 1
      t.references :transaction, index: true

      t.timestamps
    end
  end
end