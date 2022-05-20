require 'date'

# Model Rental
class Rental
  attr_accessor :id
  attr_reader :start_date, :end_date, :distance, :car_id, :commission, :actions

  OPTION_PRICES = {
    'gps' => 500,
    'baby_seat' => 200,
    'additional_insurance' => 1000
  }

  def initialize(attributes = {})
    @id = attributes[:id]
    @car_id = attributes[:car_id]
    @start_date = attributes[:start_date]
    @end_date = attributes[:end_date]
    @distance = attributes[:distance]
    @actions = []
  end

  def pricify_rental(car)
    rental_price = (price_per_day(car.price_per_day) + @distance * car.price_per_km).to_i
    @actions << { who: 'driver', type: 'debit', amount: rental_price }
    calculate_commission(rental_price)
  end

  def price_per_day(amount)
    ppd = []
    rental_period.times do
      ppd << amount
    end
    day_discount(ppd).sum
  end

  def calculate_commission(rental_price)
    total_commission = (rental_price * 0.3).to_i
    @actions << { who: 'owner', type: 'credit', amount: (rental_price * 0.7).to_i }
    @actions << { who: 'insurance', type: 'credit', amount: total_commission / 2 }
    @actions << { who: 'assistance', type: 'credit', amount: rental_period * 100 }
    @actions << { who: 'drivy', type: 'credit', amount: total_commission - (@actions[2][:amount] + @actions[3][:amount]) }
    @actions[0][:amount] += owner_additional + drivy_additional
    @actions[1][:amount] += owner_additional
    @actions[4][:amount] += drivy_additional
  end

  def rental_period
    (Date.parse(@end_date) - Date.parse(@start_date)).to_i + 1
  end

  def import_options(options_data)
    @options = options_data.select { |option| option['rental_id'] == @id }
  end

  def addtional_for_options(options)
    total = 0
    options.each do |option|
      total += OPTION_PRICES[option['type']]
    end
    total
  end

  def list_option_types
    @options.map { |option| option['type'] }
  end

  def owner_additional
    options = @options.select { |opt| opt['type'] == 'gps' || opt['type'] == 'baby_seat' }
    price_per_day(addtional_for_options(options)).to_i
  end

  def drivy_additional
    options = @options.select { |opt| opt['type'] == 'additional_insurance' }
    price_per_day(addtional_for_options(options)).to_i
  end

  def day_discount(day_list)
    day_list.each_with_index do |value, i|
      day_list[i] = value * 0.9 if i >= 1 && i <= 3
      day_list[i] = value * 0.7 if i >  3 && i <= 9
      day_list[i] = value * 0.5 if i >  9
    end
  end
end
