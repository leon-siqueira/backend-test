# List of Car objects
class Cars
  def initialize
    @cars = []
    @next_id = 1
  end

  def add(car)
    car.id = @next_id
    @next_id += 1
    @cars << car
  end

  def find(id)
    @cars.select { |car| car.id == id }.reduce
  end

  def all
    @cars
  end
end
