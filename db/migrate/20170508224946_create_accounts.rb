class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts, id: :uuid do |t|
      t.timestamps

      t.string :name,           null: false
    end

    add_index :accounts, :name, unique: true
  end
end
