class Movie < ActiveRecord::Base
    def self.ratings
        ['G','PG','PG-13','R'] # returns all ratings
    end    
end
