module ApplicationHelper

  # Retourner un titre basé sur la page.
  def title
    base_title = "LevelUp"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def sort_link text, sort
    link_to text, params.merge(sort: sort), class: (:active if params[:sort] == sort.to_s)
  end
end
