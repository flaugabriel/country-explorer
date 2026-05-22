# frozen_string_literal: true

class CreateSearchHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :search_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.string :country_name, null: false

      t.timestamps
    end

    add_index :search_histories, %i[user_id created_at]
  end
end
