require 'rubygems'
require 'httparty'
require 'Order.rb'

class VolusionAPI
 
  @@field_map = {:status => 'o.OrderStatus'};
  
  def initialize(base_uri, login, encrypted_password)
    @base_uri = base_uri
    @login = login
    @encrypted_password = encrypted_password
  end
  
  def getOrders(where = nil)
    query = {
      :Login => @login,
      :EncryptedPassword => @encrypted_password,
      :EDI_Name => 'Generic\Orders',
      :SELECT_Columns => '*'
      }
    if where
      where_field = @@field_map[where[:field]]
      if !where_field
        where_field = where[:field]
      end
      query[:WHERE_Column] = where_field
      query[:WHERE_Value] = where[:value]
    end
    result = HTTParty.get(@base_uri+'/net/WebService.aspx', :query => query)['xmldata']
    ordersHash = result['Orders']
    orders = [];
    if ordersHash
      if ordersHash.is_a? Array
        ordersHash.each do |o|
          orders.push(hash_to_order(o))
        end
      else
        orders.push(hash_to_order(ordersHash))
      end
    end
    return orders
  end
  
  private
    attr_accessor :base_uri, :login, :encrypted_password
    def hash_to_order (order_hash)
      #To get email we have to look up the customer record via:
      # :EDI_Name => 'Generic\Customers',
      # :SELECT_Columns => '*',
      # :WHERE_Column => 'CustomerID',
      # :WHERE_Value => order_hash['CustomerID']
      line_item_skus = []
      order_detail_hash = order_hash['OrderDetails']
      if order_detail_hash.is_a? Array
        order_detail_hash.each do |od|
          line_item_skus.push(hash_to_line_item(od))
        end
      else
        line_item_skus.push(hash_to_line_item(order_detail_hash))
      end
      return Order.new(order_hash['OrderID'], order_hash['BillingFirstName'], order_hash['BillingLastName'], 'todo?', line_item_skus)
    end
    
    def hash_to_line_item (order_detail_hash)
      return order_detail_hash['ProductID']
    end
end