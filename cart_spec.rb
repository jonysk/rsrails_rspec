$LOAD_PATH << File.dirname(__FILE__)
require 'rubygems'
require 'spec'

require "product"
require "cart"

describe "Product purchases" do
  before :all do
    @product1 = Product.new :id => 1, :name => "Macbook", :cost => 1990.0
    @product2 = Product.new :id => 2, :name => "Office desk", :cost => 200.0
  end

  context "adding products do the cart" do
    before :each do
      @cart = Cart.new
    end

    it "should store product and quantity" do
      @cart.add(@product1, 3)
      @cart.should have_product(@product1)
      @cart.quantity_by_product(@product1).should == 3
    end

    it "should increase the quantity when product is already in the cart" do
      2.times { @cart.add(@product1, 2) }
      @cart.quantity_by_product(@product1).should == 4
    end

    it "should identify the order as pending" do
      @cart.should be_pending
    end

    it "should identify the order as not finished" do
      @cart.should_not be_finished
    end

    it "should sum all costs taking into account quantities" do
      @cart.add(@product1, 2)
      @cart.add(@product2, 3)
      cost = (@product1.cost * 2) + (@product2.cost * 3)
      @cart.total_cost.should be_close(cost, 0.001)
    end

  end

  context "processing the cart" do
    before :each do
      @cart = Cart.new
      @valid_credit_card = mock('CreditCard', :valid? => true)
      @invalid_credit_card = mock('CreditCard', :valid? => false)
    end

    context "with invalid credit card" do

      it "should raise an error about the credit card" do
        lambda {
          @cart.process_order!(@invalid_credit_card)
        }.should raise_error(/enter a valid credit card/)
      end
    end
    
    context "with valid credit card " do

      it "should identify the order as finished" do
        lambda {
          @cart.process_order!(@valid_credit_card)
         }.should change(@cart, :finished?).from(false).to(true)
      end

      it "should no longer identify it as pending" do
        @cart.process_order!(@valid_credit_card)
        @cart.should_not be_pending
      end

    end


  end


end
