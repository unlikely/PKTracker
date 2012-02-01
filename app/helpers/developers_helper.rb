module DevelopersHelper
  def score_label(score)
    score_tag = score.upcase
    content_tag(:div, class: "score-description") do
      I18n.t("score.labels.#{score_tag}")
    end
  end

end
