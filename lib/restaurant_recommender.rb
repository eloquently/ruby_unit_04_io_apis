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
        elsif command_words[0] == "ideas"
            return recommendations
        elsif command_words[0] == "howmany"
            return count_restaurants
        elsif command_words[0] == "lookup"
            return foursquare_lookup(command_words[1], command_words[2])
        else
            "That's not going to work very well."
        end

    end

    # Import all the restaurants
    # Use the File.read method in order to make the test pass
    def import_restaurants(file_name)
        #enire contenst of filename into myfile as a string
        myfile = File.read(file_name)

        # myfile becomes a hash
        myhash = JSON.parse(myfile)

        # makes an array of hashes
        arrhash = myhash["restaurants"]

        arrhash.each do |i|
            self.restaurants << Restaurant.new(i)
        end  

        puts "Import successful."
    end

    # File.write method
    # Export all the restaurants to file_name
    def export_restaurants(file_name)
        File.write(file_name, { restaurants: self.restaurants.map(&:to_hash) }.to_json)
        puts "Export successful."
    end

    # Return a string with 2 restaurant names 
    def recommendations
        return "#{self.restaurants[0].name}, #{self.restaurants[1].name}"
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
        # need to know api credentials, get from secrets.json file
        # make sure path to secrets is correct
        # make sure secrets and gitignore are set up properly
        credentials_str = File.read('secrets.json')
        # change the json str to a hash (thatswhat JSON.parse does)
        credentials_hash = JSON.parse(credentials_str)

        # get the key and the secret out of the hash
        key = credentials_hash["foursquare_client_id"]
        secret = credentials_hash["foursquare_client_secret"]
        
        # form the url for the api call, use values from secrets hash
        # clientid and secret are my own credentials
        # v is the version which is just a date in the format YYYYMMDD
        # easier people read is not actually used, just there for my own understanding
        url = "https://api.foursquare.com/v2/venues/search?client_id=#{key}&client_secret=#{secret}&v=20160422&85044&near=#{location}&query=#{category_id}"
        # make the API call
        result = open(url).read 
        # return api results
        return result

    end 

    # This method takes a string (the result of a foursquare api call)
    # and returns an array of Restaurant objects contained in the foursquare
    # api call
    def self.import_from_foursquare(foursquare_text)
        # accepts a string
        # turn string into a hash 
        hash = JSON.parse(foursquare_text)

        # extract array of restaurant hashes from big hash
        arr = hash["response"]["venues"]

        # change the keys in the hash from strings to symbols


        # convert each restaurant hash in array to an object

        # every time you do a new api call you hunt through
        # to find the addressing and the individual info you want
        # no shortcut just hunt and convert to desired thing
        arr_rest_objs = arr.map do |restaurant_hash|
            new_hash = {
                name: restaurant_hash["name"],
                street_address: restaurant_hash["location"]["address"],
                city: restaurant_hash["location"]["city"],
                state: restaurant_hash["location"]["state"],
                zip: restaurant_hash["location"]["postalcode"],
                category: restaurant_hash["categories"][0]["name"]
            }
            Restaurant.new(new_hash)
        end
        # return array of restaurant objects 
        return arr_rest_objs

    end

    # This performs the complete search and import operation on foursquare.
    # We separated out the other methods to make our methods easier to understand
    # and test.
    def foursquare_lookup(location, category_id)
        location = "90210" if location == nil
        category_id = "food" if category_id == nil
        foursquare_results = RestaurantRecommender.search_foursquare(location, category_id)
        new_restaurants = RestaurantRecommender.import_from_foursquare(foursquare_results)
        self.restaurants += new_restaurants
        return "#{new_restaurants.count} new places in #{location} added"
    end
end


















