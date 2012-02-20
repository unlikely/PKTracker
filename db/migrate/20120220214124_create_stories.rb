class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :name
      t.string :project
      t.integer :owner_id
      t.integer :tracker_id
      t.integer :tracker_project_id
      t.integer :estimate
      t.string :story_type
      t.datetime :accepted_at

      t.timestamps
    end
  end
end
