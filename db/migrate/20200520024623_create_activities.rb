# frozen_string_literal: true

class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.string :slug
      t.string :title

      t.index(:slug, unique: true)

      t.timestamps
    end
  end
end
