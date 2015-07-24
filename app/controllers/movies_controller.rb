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

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to movies_path
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:id])

    if @movie.update_attributes(movie_params)
      redirect_to movie_path(@movie)
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path
  end

  protected

  def movie_params
    params.require(:movie).permit(
      :title, :release_date, :director, :runtime_in_minutes, :poster, :description
    )
  end

end