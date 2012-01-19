module DevelopersHelper
  def score_label(score)
    score_tag = score.upcase
    content_tag(:div, class: "score-description") do
      case score
        when Score::Win then score_tag << '!'
        else score_tag
      end
    end
  end

end
