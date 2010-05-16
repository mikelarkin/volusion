require 'VolusionAPI.rb'
api = VolusionAPI.new("http://v420173.49oy7bwf3eth.demo2.volusion.com", "petercm@gmail.com", "8A187A7462347079FA53B4A40DAFCF365F32D2009BD99D913D88534F8C49318E");
orders = api.getOrders({:field => :status, :value => 'Processing'})

orders.each do |order|
  puts "Order ##{order.id}: #{order.first_name} #{order.last_name} (#{order.email})"
  order.line_items.each do |sku|
    puts "\t" + sku
  end
end
