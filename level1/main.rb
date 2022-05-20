require_relative 'IO'
require_relative 'model/Car'
require_relative 'model/Rental'

require_relative 'repository/CarsRepository'
require_relative 'repository/RentalsRepository'

data = IO.input('data/input3.json')
out = { 'rentals' => [] }

rentals = Rentals.new
cars    = Cars.new

data['cars'].each do |car|
  cars.add(Car.new({ price_per_day: car['price_per_day'],
                     price_per_km: car['price_per_km'] }))
end

data['rentals'].each do |rental|
  rentals.add(Rental.new({ car_id: rental['car_id'],
                           start_date: rental['start_date'],
                           end_date: rental['end_date'],
                           distance: rental['distance'] }))
end

rentals.all.each do |rental|
  rental.import_options(data['options'])
  car = cars.find(rental.car_id)
  rental.pricify_rental(car)
  out['rentals'] << { id: rental.id,
                      options: rental.list_option_types,
                      actions: rental.actions }
end

IO.output('data/output5.json', out)
