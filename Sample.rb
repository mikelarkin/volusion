require File.dirname(__FILE__) + '/lib/volusion_api'
                                            
# Test Shop
# url = "http://v420173.49oy7bwf3eth.demo2.volusion.com"
# login = "petercm@gmail.com"
# password = "8A187A7462347079FA53B4A40DAFCF365F32D2009BD99D913D88534F8C49318E"

# F-Stop                         
url = "http://jqjle.xrqvr.servertrust.com"
login = "mikelarkin@pixellent.com"
password = "50FE40E36A0965E353FD5F0A29CD8C157383F6CDE59223540828722D22F54935"

api = Volusion::API.new(url, login, password)

puts "--------All Orders with status 'Processing'--------"
orders = api.getOrders({:field => :status, :value => 'Processing'}) 
return "No orders" if orders.nil?
orders.each do |order|
  puts "Order ##{order.id}: #{order.first_name} #{order.last_name} (#{order.email}) | #{order.status}"
  order.line_items.each do |li|
    puts "\t LI ##{li.id}: #{li.title} (#{li.sku}) @ #{li.price}"
  end
end  

puts "\n--------Order by ID (2)--------------------"
orders = api.getOrders({:field => :orderId, :value => 2})
return "No orders" if orders.nil?
orders.each do |order|
  puts "Order ##{order.id}: #{order.first_name} #{order.last_name} (#{order.email}) | #{order.status}"
  order.line_items.each do |li|
    puts "\t LI ##{li.id}: #{li.title} (#{li.sku}) @ #{li.price}"
  end
end