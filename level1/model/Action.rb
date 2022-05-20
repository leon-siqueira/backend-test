class Action
  attr_reader :who, :type, :amount

  def initialize(attributes = {})
    @who = attributes[:who]
    @type = attributes[:type]
    @amount = attributes[:amount]
  end
end
