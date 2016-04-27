require 'open-uri'
require 'json'

secrets = JSON.parse(File.read('unit_04_lecture/secrets.json'))
url = "https://api.foursquare.com/v2/venues/search?near=85251&v=20160426&client_id=#{secrets["foursquare_client_id"]}&client_secret=#{secrets["foursquare_client_secret"]}&categoryid=4d4b7105d754a06374d81259"

=begin
https://api.foursquare.com/client_id=#{secrets["foursquare_client_id"]}&client_secret=#{secrets["foursquare_client_secret"]}
https://api.foursquare.com/v2/venues/40a55d80f964a52020f31ee3?v=20160426&client_id=#{secrets["foursquare_client_id"]}&client_secret=#{secrets["foursquare_client_secret"]}
=end
file = open(url)

result_str = file.read

result_hash = JSON.parse(result_str)

restaurants = result_hash["response"]["venues"]

restaurants.map { |r| r["name"]}