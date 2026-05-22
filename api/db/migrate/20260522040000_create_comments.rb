class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :country_code, null: false
      t.references :user, foreign_key: true, null: true
      t.string :user_email, null: false
      t.text :content, null: false
      t.integer :likes_count, default: 0
      t.integer :dislikes_count, default: 0
      t.timestamps
    end
    add_index :comments, :country_code
  end
end
