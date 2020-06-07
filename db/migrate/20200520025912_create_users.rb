# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  enable_extension "pgcrypto" unless extension_enabled? "pgcrypto"

  def change
    create_table :users, id: :uuid, default: "gen_random_uuid()" do |t|
      t.boolean :is_admin, default: false
      t.integer :age

      t.string :city
      t.string :country
      t.string :email, unique: true
      t.string :gender
      t.string :links, array: true
      t.string :name
      t.string :state

      t.timestamps

      t.index :email
      t.index :links, using: "gin"
    end
  end
end
