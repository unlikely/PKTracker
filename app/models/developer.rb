class Developer < ActiveRecord::Base
  validates_presence_of :name
  validates_numericality_of :points_accepted, allow_blank: true

  # prevent negative numbers

  def time_since_question(now)
    ((now - last_question)/1.hour).round(3)
  end

  def time_since_broke_production(now)
    ((now - last_broke_production)/1.day).round(0)
  end
end
