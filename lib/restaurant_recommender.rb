require 'json'
require 'open-uri'
require_relative 'restaurant'

class RestaurantRecommender
    attr_accessor :restaurants

    def initialize(restaurants=[ ])
        self.restaurants = restaurants
    end

    # Takes command entered by user and calls the appropriate method.
    # e.g. if command == "export output.json" this method should
    # return the result of self.export_restaurants('output.json')

    # The names of the commands are up to you. The specs for this method
    # are outlined in the spec file, but you need to write them. Your life
    # will be easier if you choose to make the command one word (e.g. export,
    # import, recommend, count, lookup)

    # The import command is provided as an example (tests included as well)
    def dispatch_command(command)
        command_words = command.split(' ')

        if command_words[0] == "import"
            return import_restaurants(command_words[1])
        end
        
        if command_words[0] == "export"
            return export_restaurants(command_words[1])
        end
        
        if command_words[0] == "recommendations"
            return recommendations
        end
        
        if command_words[0] == "count_restaurants"
            return count_restaurants
        end
        
        if command_words[0] == "foursquare_lookup"
            return foursquare_lookup(command_words[1])
        end
    end

    # Import all the restaurants
    # Use the File.read method in order to make the test pass
    def import_restaurants(file_name)
        new_restaurants = JSON.parse(File.read(file_name))["restaurants"]
        new_restaurants.each do |x|
            self.restaurants << Restaurant.new(x)
        end
    end

    # Export all the restaurants to file_name
    def export_restaurants(file_name)
        File.write(file_name, {restaurants: self.restaurants.map(&:to_hash)}.to_json)
    end

    # Return a string with 2 restaurant names
    def recommendations
        return self.restaurants[0].name + " " + self.restaurants[1].name
    end

    # Return the number of restaurants available
    def count_restaurants
        return self.restaurants.count
    end

    # Search foursquare for venues in the given category
    # The method should return a string containing the results of the call
    # to the venues/search endpoint using location as the "near" parameter
    # The default category id below is for the "Food" category

    # You don't have to test this method ... we'll discuss how to do this later
    def self.search_foursquare(location, category_id)
        secrets = JSON.parse(File.read('secrets.json'))
        client_id = ''
        url = 'https://api.foursquare.com/v2/venues/search?near='+location+'&categoryID='+category_id+'&client_id=#{secrets["foursquare_client_id"]}&client_secret=#{secrets["foursquare_client_secrets"]}'
        file = open(url)
        return file.read
    end

    # This method takes a string (the result of a foursquare api call)
    # and returns an array of Restaurant objects contained in the foursquare
    # api call
    def self.import_from_foursquare(foursquare_text)
        venues = JSON.parse(foursquare_text)["response"]["venues"]
        restaurants = []
        venues.each do |r|
            hash = {name: r["name"], street_address: r["address"],
            city: r["city"], state: r["state"], zip: r["postalCode"],
            category: r["categories"][0]["shortName"]}
            restaurants << Restaurant.new(hash)
        end
        return restaurants
    end

    # This performs the complete search and import operation on foursquare.
    # We separated out the other methods to make our methods easier to understand
    # and test.
    def foursquare_lookup(location, category_id='4d4b7105d754a06374d81259')
        foursquare_results = RestaurantRecommender.search_foursquare(location, category_id)
        new_restaurants = RestaurantRecommender.import_from_foursquare(foursquare_results)
        self.restaurants += new_restaurants
        return "#{new_restaurants.count} new restaurants added"
    end
end