require 'open-uri'
require 'json'

secrets = JSON.parse(File.read('secrets.json'))

https://api.foursquare.com/client_id=#{secrets["foursquare_client_id"]}&client_secret=#{secrets["foursquare_client_secret"]}

file = open(url)

result_str = file.read

result_hash = JSON.parse(result_str)

restaurants = result_hash["response"]["venues"]

restaurants.map { |r| r["name"]}