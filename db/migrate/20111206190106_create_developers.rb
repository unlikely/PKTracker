class CreateDevelopers < ActiveRecord::Migration
  def change
    create_table :developers do |t|
      t.string :name
      t.integer :points_accepted
      t.datetime :last_question
      t.datetime :last_broke_production

      t.timestamps
    end
  end
end
