require 'restaurant_recommender'

describe RestaurantRecommender do
    let(:restaurants) do
        [ Restaurant.new(name: 'Restaurant 1'),
          Restaurant.new(name: 'Restaurant 2') ]
    end

    let(:rr) { RestaurantRecommender.new(restaurants) }

    describe "#import_restaurants" do
        it 'adds new restaurants' do
            file = mock('file')
            allow { File }.to receive(:open).with("filename").and_yield(file)
            allow { File }.to receive(:read).and_return('{ "restaurants": [ { "name": "Restaurant from file } ] }')

            expect { rr.import_restaurants('filename') }.to change { rr.restaurants.count }.by 1
        end
    end

    describe "#export_restaurants" do
        it "should create 'filename' and put 'text' in it" do
            require 'json'
            file = mock('file')
            expect { File }.to receive(:open).with("filename", "w").and_yield(file)
            expect { file }.to receive(:write).with({ restaurants: rr.restaurants.map(&:to_hash) }.to_json)
        end
    end

    describe 'RestaurantRater#import_from_foursquare' do
        let(:foursquare_text) do
            open('../data/foursquare.json').read
        end

        let(:imported_restaurants) do
            RestaurantRater.import_from_foursquare(foursquare_text)
        end

        it 'imports correct number of venues' do
            expect(imported_restaurants.count).to eq(19)
        end

        it 'gives each restaurant a name' do
            expect(imported_restaurants.map(&:name).reject(&:nil?).count).to eq(19)
        end

        it 'gives each restaurant a category' do
            expect(imported_restaurants.map(&:category).reject(&:nil?).count).to eq(19)
        end
    end

end
