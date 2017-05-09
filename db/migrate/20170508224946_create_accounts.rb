class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts, id: :uuid do |t|
      t.timestamps

      t.string :name,           null: false
      t.jsonb :settings,        null: false, default: {}
    end

    add_index :accounts, :name, unique: true
  end
end
