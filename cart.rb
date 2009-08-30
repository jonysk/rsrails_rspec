class Cart

  attr_reader :state
  
  def initialize
    @products = {}
    @state = 'pending'
  end
  
  def add(product, quantity)
    @products[product] ||= 0
    @products[product] += quantity
  end
  
  def has_product?(product)
    @products.has_key?(product)
  end
  
  def quantity_by_product(product)
    @products[product] || 0
  end
  
  def total_cost
    @products.inject(0) { |total, item| total += item.first.cost * item[1] }
  end
  
  def pending?
    @state == 'pending'
  end
  
  def finished?
    @state == 'paid'
  end
  


  def process_order!(credit_card)
    raise "Please enter a valid credit card" unless credit_card.valid?
    # payment procedures
    payment_made!
    true
  end
  
  private 
  
    def payment_made!
      @state = 'paid'
    end
  
end
