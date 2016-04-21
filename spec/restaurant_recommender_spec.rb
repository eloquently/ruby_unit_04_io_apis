require 'json'
require 'restaurant_recommender'

describe RestaurantRecommender do
    let(:restaurants) do
        [ Restaurant.new(name: 'Restaurant 1'),
          Restaurant.new(name: 'Restaurant 2') ]
    end

    let(:rr) { RestaurantRecommender.new(restaurants) }

    describe "#import_restaurants" do
        it 'adds new restaurants' do
            data = { restaurants: [ { name: 'Restaurant 3'} ] }
            allow(File).to receive(:read).and_return(data.to_json)
            expect { rr.import_restaurants('filename') }.to change { rr.restaurants.count }.by 1
        end
    end

    describe "#export_restaurants" do
        it "creates 'filename' and puts the appropriate text in it" do
            file = double('file')
            expect(File).to receive(:open).with("filename", "w").and_yield(file)
            expect(file).to receive(:write).with({ restaurants: rr.restaurants.map(&:to_hash) }.to_json)
        end
    end

    describe '#recommendations' do
        it 'returns a string with Restaurant 1 and Restaurant 2'
    end

    describe '#count_restaurants' do
        it 'returns the number of restaurants'
    end

    describe '#dispatch_command' do
        it 'calls import_restaurants' do
            expect(rr).to receive(:import_restaurants).with('file_name.json').and_return(nil)
            rr.dispatch_command('import file_name.json')
        end

        it 'calls export_restaurants'

        it 'calls search_foursquare'

        it 'calls recommendations'

        it 'calls count_restaurants'
    end

    describe 'RestaurantRecommender#import_from_foursquare' do
        let(:foursquare_text) do
            open('data/foursquare.json').read
        end

        let(:imported_restaurants) do
            RestaurantRecommender.import_from_foursquare(foursquare_text)
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
