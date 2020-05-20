# frozen_string_literal: true

class CreateInterests < ActiveRecord::Migration[6.0]
  def change
    create_table :interests do |t|
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
      t.belongs_to :activity, null: false, foreign_key: true
      t.jsonb :details, null: false, default: "{}"

      t.timestamps
    end
  end
end
