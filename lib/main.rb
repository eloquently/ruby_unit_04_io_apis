# This program will run your restaurant recommender
# to run it execute the following command in your bash terminal:
# ruby lib/main.rb

require_relative 'restaurant_recommender'
rr = RestaurantRecommender.new()

puts "Welcome to restaurant recommender"
while true
    print ' > '
    input = gets.chomp
    break if input == "quit"

    puts rr.dispatch_command(input)
end
