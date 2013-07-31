class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :code, limit: 3, null: false, default: 0
      t.string :name, limit: 64, null: false, default: 'tr001'
      t.text :description, limit: 255
      t.text :argument, limit: 255
      t.integer :answerType, limit: 2, null: false, default: 0
      t.text :answer, limit: 255

      t.timestamps
    end
  end
end
