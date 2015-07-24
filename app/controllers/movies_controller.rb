class MoviesController < ApplicationController

  def index
    @movies = Movie.all
  end

  def search
    title = "%#{params[:title]}%".downcase
    director = "%#{params[:director]}%".downcase
    
    case params[:duration]
    when "Any"
      duration = nil
    when "Under 90 minutes"
      duration = "runtime_in_minutes < 90"
    when "Between 90 and 120 minutes"
      duration = "runtime_in_minutes BETWEEN 90 AND 120"
    when "Over 120 minutes"
      duration = "runtime_in_minutes > 120"
    end

    @movies = Movie.where("lower(title) LIKE ?", title)
      .where("lower(director) LIKE ?", director)
      .where(duration)
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