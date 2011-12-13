class Developer < ActiveRecord::Base
  validates_presence_of :name
  validates_numericality_of :points_accepted, allow_blank: true

  def time_since_question(now=Time.zone.now)
    ((now - last_question)/1.hour).round(3)
  end

  def time_since_broke_production(now=Time.zone.now)
    ((now - last_broke_production)/1.day).floor
  end

  def as_json(options={})
    super(:methods => [:time_since_question, :time_since_broke_production])
  end
end
