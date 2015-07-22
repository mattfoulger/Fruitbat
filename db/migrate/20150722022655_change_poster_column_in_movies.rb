class ChangePosterColumnInMovies < ActiveRecord::Migration
  def change
    change_table :movies do |t|
      t.rename :poster_image_url, :poster
    end
  end
end
