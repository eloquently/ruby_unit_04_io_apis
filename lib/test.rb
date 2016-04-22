require 'json'
require 'open-uri'

location = "85044"
category_id = "food"

credentials_str = File.read('secrets.json')
# change the json str to a hash (thatswhat JSON.parse does)
credentials_hash = JSON.parse(credentials_str)

puts credentials_hash

key = credentials_hash["foursquare_client_id"]
secret = credentials_hash["foursquare_client_secret"]

puts key
puts secret

# form the url for the api call, use values from secrets hash
# clientid and secret are my own credentials
# v is the version which is just a date in the format YYYYMMDD
# easier people read is not actually used, just there for my own understanding
url = "https://api.foursquare.com/v2/venues/search?client_id=#{key}&client_secret=#{secret}&v=20160422&85044&near=#{location}&query=#{category_id}"
# make the API call
result = open(url).read 
puts result