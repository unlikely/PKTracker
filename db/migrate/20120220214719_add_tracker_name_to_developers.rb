class AddTrackerNameToDevelopers < ActiveRecord::Migration
  def change
    add_column :developers, :tracker_name, :string, after: :name
  end
end
