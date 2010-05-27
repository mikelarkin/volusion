require 'rubygems'
require 'httparty'
module Volusion
  class API

    @@field_map = {
      :status => 'o.OrderStatus',
      :orderId => 'o.OrderID',
      :customerId => 'CustomerID'
    };

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
      where_query(where, query)
      ordersHash = HTTParty.get(@base_uri+'/net/WebService.aspx', :query => query)['xmldata']['Orders']
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

    def getCustomers(where = nil)
      query = {
        :Login => @login,
        :EncryptedPassword => @encrypted_password,
        :EDI_Name => 'Generic\Customers',
        :SELECT_Columns => '*'
      }
      where_query(where, query)
      customerHash = HTTParty.get(@base_uri+'/net/WebService.aspx', :query => query)['xmldata']['Customers']
      customers = []
      if customerHash
        if customerHash.is_a? Array
          customers = customerHash
          # TODO: hash customer class?
          #        customerHash.each do |c|
          #        end
        else
          # TODO: hash to customer class?
          customers = [customerHash];
        end
      end
      return customers
    end

    private
    attr_accessor :base_uri, :login, :encrypted_password
    def hash_to_order (order_hash)
      line_items = []
      order_detail_hash = order_hash['OrderDetails']
      if order_detail_hash.is_a? Array
        order_detail_hash.each do |od|
          line_items.push(hash_to_line_item(od))
        end
      else
        line_items.push(hash_to_line_item(order_detail_hash))
      end
      customer = getCustomers({:field => :customerId, :value => order_hash['CustomerID']})[0]
      return Volusion::Order.new(order_hash['OrderID'], order_hash['BillingFirstName'], order_hash['BillingLastName'], customer['EmailAddress'], line_items, order_hash['OrderStatus'])
    end

    def hash_to_line_item (order_detail_hash)
      Volusion::LineItem.new(order_detail_hash['OrderDetailID'], order_detail_hash['ProductName'], order_detail_hash['ProductID'], order_detail_hash['ProductPrice'])
    end

    def where_query(where, query)
      if where
        where_field = @@field_map[where[:field]]
        if !where_field
          where_field = where[:field]
        end
        query[:WHERE_Column] = where_field
        query[:WHERE_Value] = where[:value]
      end
    end
  end
end
