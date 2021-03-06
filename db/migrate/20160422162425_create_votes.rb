class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :question, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :is_up

      t.timestamps null: false
    end
  end
end
