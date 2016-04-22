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
        elsif command_words[0] == "export"
            return export_restaurants(command_words[1])
        elsif command_words[0] == "recommend"
            return recommendations
        elsif command_words[0] == "count"
            return count_restaurants
        elsif command_words[0] == "search"
            return foursquare_lookup(command_words[1],command_words[2])
        end
    end

    # Import all the restaurants
    # Use the File.read method in order to make the test pass
    def import_restaurants(file_name)
        file_name ||= 'restaurants.json'
        imported_array = JSON.parse(File.read(file_name))["restaurants"]
        imported_array.each do |i|
            self.restaurants << Restaurant.new(i)
        end
    end

    # Export all the restaurants to file_name
    def export_restaurants(file_name)
        file_name ||= 'restaurants.json'
        File.write(file_name, { restaurants: self.restaurants.map(&:to_hash) }.to_json)
    end

    # Return a string with 2 restaurant names
    def recommendations
        return "#{self.restaurants[0].name}, #{self.restaurants[1].name}"
    end

    # Return the number of restaurants available
    def count_restaurants
        return restaurants.count
    end

    # Search foursquare for venues in the given category
    # The method should return a string containing the results of the call
    # to the venues/search endpoint using location as the "near" parameter
    # The default category id below is for the "Food" category

    # You don't have to test this method ... we'll discuss how to do this later
    def self.search_foursquare(location, criteria)
        secret_hash = JSON.parse(File.read('secrets.json'))
        key = secret_hash.keys[0]
        secret = secret_hash.values[0]
        url = "https://api.foursquare.com/v2/venues/search?client_id=#{key}&client_secret=#{secret}&v=20130815&near=#{location}&query=#{criteria}"
        result = open(url).read
        return result
    end

    # This method takes a string (the result of a foursquare api call)
    # and returns an array of Restaurant objects contained in the foursquare
    # api call
    def self.import_from_foursquare(foursquare_string)
        hash = JSON.parse(foursquare_string)
        restaurant_hash_array = hash["response"]["venues"]
        result = restaurant_hash_array.map do |restaurant_hash|
            new_hash = {
                name: restaurant_hash["name"],
                street_address: restaurant_hash["location"]["address"],
                city: restaurant_hash["location"]["city"],
                state: restaurant_hash["location"]["state"],
                zip: restaurant_hash["location"]["postalCode"],
                category: restaurant_hash["categories"][0]["name"]
            }
            Restaurant.new(new_hash)
        end
        return result
        #return array of restaurant objects
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