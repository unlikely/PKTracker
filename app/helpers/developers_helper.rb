module DevelopersHelper
  def score_label(score)
    content_tag(:div, class: "score-description #{score}") do
      score.upcase
    end
  end

end
