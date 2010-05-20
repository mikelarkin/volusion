module Volusion
  class LineItem
    attr_accessor :id, :title, :sku, :price

    def initialize(id, title, sku, price)
      @id = id
      @title = title
      @sku = sku
      @price = price;
    end
  end
end
