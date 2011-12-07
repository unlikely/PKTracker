class Developer < ActiveRecord::Base
  validates_presence_of :name
  validates_numericality_of :points_accepted, allow_blank: true
end
