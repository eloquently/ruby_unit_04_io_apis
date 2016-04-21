class Restaurant
    attr_accessor :name
    attr_writer :street_address, :city, :state, :zip
    def initialize(options)
        self.name = options[:name]
        self.street_address = options[:name]
        self.city = options[:city]
        self.state = options[:zip]
        self.zip = options[:zip]
    end

    # This method takes a string (the result of a foursquare api call)
    # and returns an array of Restaurant objects contained in the foursquare
    # api call
    def self.import_from_foursquare(foursquare_text)
    end
end
