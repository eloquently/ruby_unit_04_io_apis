require 'restaurant'

describe Restaurant do

    let(:restaurant_no_street) do
        Restaurant.new( name: "Mucha Lucha Taco Shop",
                        city: "Tempe",
                        state: "AZ",
                        zip: "85282",
                        category: "Taco Place")
    end

    let(:restaurant) do
        Restaurant.new( name: "Pop Sickels Stand",
                        street_address: "1706 S College Ave",
                        city: "Tempe",
                        state: "AZ",
                        zip: "85281",
                        category: "Ice Cream Shop")
    end

    describe '#full_address' do
        context 'when all address variables present' do
            it 'returns a full address' do
                expect(restaurant.full_address).to eq("1706 S College Ave, Tempe, AZ 85281")
            end
        end
        context 'when not all address variables present' do
            it 'returns nil' do
                expect(restaurant_no_street.full_address).to eq(nil)
            end
        end
    end

    describe 'Restaurant#import_from_foursquare' do
        let(:foursquare_text) do
            open('../data/foursquare.json').read
        end

        let(:imported_restaurants) do
            Restaurant.import_from_foursquare(foursquare_text)
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