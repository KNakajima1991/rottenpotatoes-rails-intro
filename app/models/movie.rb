class Movie < ActiveRecord::Base
    
    def self.all_ratings
        allRatings = Movie.uniq.pluck(:rating)
        return allRatings
    end
    
end
