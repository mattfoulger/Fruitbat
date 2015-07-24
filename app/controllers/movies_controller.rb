class MoviesController < ApplicationController

  def index
    @movies = Movie.all
    # respond_to :html, :json
  end

  def search
    @movies = Movie.query(params[:query])
    case params[:duration]
    when "short"
      @movies = @movies.short
    when "medium"
      @movies = @movies.medium
    when "long"
      @movies = @movies.long
    end
    @movies
  end

  def highest_rated
    @movies = Movie.highest_rated
  end

  def show
    @movie = Movie.find(params[:id])
  end

end