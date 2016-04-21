rr = RestaurantRecommender.new()

puts "Welcome to restaurant recommender"
while true
    input = gets.chomp
    break if input == "quit"

    puts rr.dispatch_command(input)
end
