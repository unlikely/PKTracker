class AlterPointsToFractional < ActiveRecord::Migration
  def up
    change_column(:developers, :points_accepted, :decimal, :precision => 8, :scale => 2)
  end

  def down
    change_column(:developers, :points_accepted, :integer)
  end
end
