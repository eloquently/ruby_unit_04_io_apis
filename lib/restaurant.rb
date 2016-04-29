class Restaurant
    attr_accessor :name, :category
    attr_writer :street_address, :city, :state, :zip
    def initialize(options={})
        self.name = options[:name]
        self.street_address = options[:street_address]
        self.city = options[:city]
        self.state = options[:state]
        self.zip = options[:zip]
        self.category = options[:category]
    end

    # This method combines street_address, city, state, and zip into an
    # address that you can search in Google Maps. See the spec file for
    # an example format.

    # Note that we don't have getter methods for the address component
    # variables, so you need to access the instance variable directly
    # by using the @ syntax (e.g. @street_address rather than
    # self.street_address)
    def full_address
        if @street_address == nil ||
            @city == nil ||
            @state == nil ||
            @zip == nil
            return nil
        else
            return "#{@street_address}, #{@city}, #{@state} #{@zip}"
        end
       # 1706 S College Ave, Tempe, AZ 85281
    end

    # This method returns a hash with keys equal to the instance variable
    # names and values equal to the values from those instance variables
    def to_hash
        return {
            name: self.name,
            street_address: @street_address,
            city: @city,
            state: @state,
            zip: @zip,
            category: self.category
        }
    end
end
