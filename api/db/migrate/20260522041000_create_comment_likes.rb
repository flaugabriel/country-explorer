class CreateCommentLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :comment_likes do |t|
      t.references :comment, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :like, null: false
      t.timestamps
    end
    add_index :comment_likes, [:comment_id, :user_id], unique: true
  end
end
