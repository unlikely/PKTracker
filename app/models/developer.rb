class Developer < ActiveRecord::Base
  validates_presence_of :name
  validates_numericality_of :points_accepted, allow_blank: true

  def time_since_question(now=Time.zone.now)
    ((now - last_question)/1.hour).round(3)
  end

  def time_since_question_score
    case (time_since_question * 100).to_i
      when (0..400) then Score::Great
      when (401..800) then Score::Nominal
      when (801..1590) then Score::Weak
      else Score::Fail
    end
  end

  def time_since_broke_production(now=Time.zone.now)
    ((now - last_broke_production)/1.day).floor
  end

  def as_json(options={})
    super(:methods => [:time_since_question, :time_since_broke_production])
  end

end
