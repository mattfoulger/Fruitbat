class Movie < ActiveRecord::Base
  has_many :reviews

  validates :title, presence: true
  validates :director, presence: true
  validates :runtime_in_minutes, numericality: { only_integer: true }
  validates :description, presence: true
  validates :poster, presence: true
  validates :release_date, presence: true

  mount_uploader :poster, PosterUploader

  scope :query, ->(query) { where("lower(title || director) LIKE ?", "%#{query}%") }
  scope :short, -> { where("runtime_in_minutes < 90") }
  scope :medium, -> { where("runtime_in_minutes BETWEEN 90 AND 120") }
  scope :long, -> { where("runtime_in_minutes > 120") }
  scope :highest_rated, -> { joins(:reviews).order("AVG(reviews.rating_out_of_ten) DESC").group("movies.id").having("AVG(reviews.rating_out_of_ten) > 5") }

  def review_average
    if reviews.size == 0
      return 0
    else
      reviews.sum(:rating_out_of_ten)/reviews.size
    end
  end

  protected

  # def release_date_is_in_the_future
  #   if release_date.present?
  #     errors.add(:release_date, "should probably be in the future") if release_date < Date.today
  #   end
  # end

end
