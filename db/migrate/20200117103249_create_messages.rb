class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.timestamps

      t.string :email, null: false, index: true
      t.string :first_name, null: false, index: true
      t.string :last_name, null: false, index: true
      t.integer :amount, null: false, index: true
    end
  end
end
