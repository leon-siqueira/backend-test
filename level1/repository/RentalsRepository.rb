# List of Rental objects
class Rentals
  def initialize
    @rentals = []
    @next_id = 1
  end

  def add(rental)
    rental.id = @next_id
    @next_id += 1
    @rentals << rental
  end

  def find(id)
    @rentals.select { |rental| rental.id == id }.reduce
  end

  def all
    @rentals
  end
end
