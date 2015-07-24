class Movie < ActiveRecord::Base
  has_many :reviews

  validates :title, presence: true
  validates :director, presence: true
  validates :runtime_in_minutes, numericality: { only_integer: true }
  validates :description, presence: true
  validates :poster, presence: true
  validates :release_date, presence: true
  validate :release_date_is_in_the_future

  mount_uploader :poster, PosterUploader

  scope :query, ->(query) { where("lower(title || director) LIKE ?", "%#{query}%") }
  scope :short, -> { where("runtime_in_minutes < 90") }
  scope :medium, -> { where("runtime_in_minutes BETWEEN 90 AND 120") }
  scope :long, -> { where("runtime_in_minutes > 120") }

  # def self.search(params)
  #   @movies = Movie.all
  #   params.each_pair do |k, v|
  #     @movies = @movies.send(k, v.downcase)
  #   end
  # end

  # def self.search(params)
  #   chain = []
  #   chain << [:title, params[:title].downcase] if params[:title]
  #   chain << [:director, params[:director].downcase] if params[:director]
  #   chain << [:short] if params[:duration] && params[:duration] == "short"
  #   chain << [:medium] if params[:duration] && params[:duration] == "medium"
  #   chain << [:long] if params[:duration] && params[:duration] == "long"
  #   chain.inject(Movie.all) { |obj, method_with_args| obj.send(*method_with_args)}
  # end

  def review_average
    if reviews.size == 0
      return 0
    else
      reviews.sum(:rating_out_of_ten)/reviews.size
    end
  end

  protected

  def duration(scope)
    send(scope)
  end

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should probably be in the future") if release_date < Date.today
    end
  end

end
