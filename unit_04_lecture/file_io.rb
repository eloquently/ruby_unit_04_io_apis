require 'json'
require "pp"

str = File.read('data/example.json')

hash = JSON.parse(str)

puts hash.inspect

pp hash