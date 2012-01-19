class Developer < ActiveRecord::Base
  validates_presence_of :name
  validates_numericality_of :points_accepted, allow_blank: true

  def time_since_question(now=Time.zone.now)
    ((now - last_question)/1.hour).round(1)
  end

  def time_since_question_score
    case (time_since_question * 10).to_i
      when (0..60) then Score::Great
      when (61..300) then Score::Nominal
      when (301..609) then Score::Weak
      else Score::Fail
    end
  end

  def time_since_broke_production(now=Time.zone.now)
    ((now - last_broke_production)/1.day).floor
  end

  def time_since_broke_production_score
    case (time_since_broke_production).to_i
      when (0..2) then Score::Fail
      when (3..9) then Score::Weak
      when (10..19) then Score::Nominal
      else Score::Great
    end
  end

  def points_accepted_score
    case (points_accepted * 100).to_i
      when (0..99) then Score::Fail
      when (100..299) then Score::Weak
      when (300..499) then Score::Nominal
      else Score::Great
    end
  end

  def as_json(options={})
    super(:methods => [:time_since_question, :time_since_broke_production])
  end

end
