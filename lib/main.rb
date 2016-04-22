# This program will run your restaurant recommender
# to run it execute the following command in your bash terminal:
# ruby lib/main.rb

require_relative 'restaurant_recommender'
rr = RestaurantRecommender.new()
puts " "
puts " "
puts "- - - - - - - - - - - - - - - - - - - - - - - - - - - -"
puts " "
puts "Hungry? Or worse: HANGRY? We have a solution for you!"
puts "Start by typing: "
puts "                 lookup yourlocation yourcategory"
puts "Then you can:"
puts "                 ideas (list of recomendations)"
puts "                 howmany (count of results)" 
puts "                 export yourstoredfilename (save your list for later)"
puts "                 import yourfilename (import an old list)"
puts "                 quit (get outa here!)"
while true
    print ' > '
    input = gets.chomp

    break if input == "quit"

    puts rr.dispatch_command(input)
end
