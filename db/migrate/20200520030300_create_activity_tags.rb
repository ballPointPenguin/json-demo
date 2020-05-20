# frozen_string_literal: true

class CreateActivityTags < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_tags do |t|
      t.belongs_to :activity, null: false, foreign_key: true
      t.belongs_to :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
