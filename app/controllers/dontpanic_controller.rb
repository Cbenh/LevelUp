# encoding: utf-8
class DontpanicController < ApplicationController
  before_filter :require_login
  skip_before_filter :require_login, only: [:show]

  # before_filter :require_dontpanic

  def index
    @tutorials = current_user.tutorials
    @sorts = [
      ["alphabetique", "title"],
      ["parution", "published_at"]
    ]
    case params[:sort]
    when "title"
      @tutorials = @tutorials.sort_by(&:title)
    when "published_at"
      @tutorials = @tutorials.sort_by(&:published_at)
    end
    if @tutorials.empty?
      return redirect_to dontpanic_search_path, notice: "Vous ne possédez pas encore de tutoriels"
    end
  end

  def search
    @newest_tutorials = current_user.newest_tutorials(15)
  end

  def results
    @title = "Tutos pour « #{params[:query]} »"
    @results = current_user.search_tutorials params[:query]
    @sorts = [
      ["pertinence", nil],
      ["téléchargements", "downloads"],
      ["note", "score"]
    ]
    case params[:sort]
    when "downloads"
      @results = @results.sort_by(&:downloads).reverse
    when "score"
      @results = @results.sort_by(&:score).reverse
    end
  end

  def categories
    @title = "Derniers Tutos sortis"
    @results = current_user.newest_tutorials(15).sort_by(&:published_at).reverse
    render :results
  end

  def category
    category = current_user.dontpanic_categories.find{|c| c.id == params[:id].to_i}
    @title = "Tutos de « #{category ? category.name : "???"} »"
    @results = current_user.dontpanic_category_tutorials(params[:id])
    if @results.is_a? StandardError
      return redirect_to (request.referer || dontpanic_search_path), alert: @results.to_s
    end
    @sorts = [
      ["téléchargements", "downloads"],
      ["note", "score"]
    ]
    params[:sort] = params[:sort].presence || "downloads"
    case params[:sort]
    when "downloads"
      @results = @results.sort_by(&:downloads).reverse
    when "score"
      @results = @results.sort_by(&:score).reverse
    end
    render :results
  end

  def show
    @tutorial = current_user.tutorial(params[:id])
    @step = []
      if params[:page].present? && params[:page].to_i > 0
        (1.. @tutorial.step_count).each do |i|
      @step.push @tutorial.step(i)
      end
      render :tutorial_step
    else
      render :tutorial_title
    end
  end

  def update
    @tutorial = current_user.tutorial(params[:id])
    response = current_user.update_grade(params[:id], params[:score])
     unless response.is_a? StandardError
      redirect_to dontpanic_tutorial_path(id: @tutorial.id, page: 0), notice: "Note Enregistrée"
    else
      redirect_to dontpanic_path(), alert: response.message
    end
  end

  def download
    res = current_user.download_tutorial(params[:id])
    if res.is_a? StandardError
      message = { alert: res.to_s }
    else
      message = { notice: "Le tutoriel a été ajouté à vos téléchargements" }
    end
    redirect_to :back, message
  end

  def delete
    res = current_user.delete_tutorial(params[:id])
    if res.is_a? StandardError
      message = { alert: res.to_s }
    else
      message = { notice: "Le tutoriel a été supprimé de vos téléchargements" }
    end
    redirect_to :back, message
  end

  private

  def require_dontpanic
    unless current_user.downloaded? 2
      redirect_to (request.referer || home_path),
        alert: "Vous devez télécharger DontPanic pour effectuer cette action"
    end
  end
end
