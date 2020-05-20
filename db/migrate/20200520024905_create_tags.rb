# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :title
      t.string :slug

      t.index(:slug, unique: true)

      t.timestamps
    end
  end
end
