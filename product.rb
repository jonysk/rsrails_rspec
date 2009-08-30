class Product
  
  attr_accessor :name, :cost
  attr_reader :id
  
  def initialize(attrs = {})
    @id = attrs[:id]
    @name = attrs[:name]
    @cost = attrs[:cost]
  end
end