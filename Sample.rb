require File.dirname(__FILE__) + '/lib/volusion_api'

api = Volusion::API.new("http://v420173.49oy7bwf3eth.demo2.volusion.com", "petercm@gmail.com", "8A187A7462347079FA53B4A40DAFCF365F32D2009BD99D913D88534F8C49318E");

puts "--------All Orders with status 'Processing'--------"
orders = api.getOrders({:field => :status, :value => 'Processing'})
orders.each do |order|
  puts "Order ##{order.id}: #{order.first_name} #{order.last_name} (#{order.email})"
  order.line_items.each do |li|
    puts "\t LI ##{li.id}: #{li.title} (#{li.sku}) @ #{li.price}"
  end
end  

puts "\n--------Order by ID (2)--------------------"
orders = api.getOrders({:field => :orderId, :value => 2})
orders.each do |order|
  puts "Order ##{order.id}: #{order.first_name} #{order.last_name} (#{order.email}) | #{order.status}"
  order.line_items.each do |li|
    puts "\t LI ##{li.id}: #{li.title} (#{li.sku}) @ #{li.price}"
  end
end