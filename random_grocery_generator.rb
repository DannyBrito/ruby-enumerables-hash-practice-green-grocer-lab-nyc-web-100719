require_relative 'grocer'

def items
	[
		{"AVOCADO" => {:price => 3.00, :clearance => true}},
		{"KALE" => {:price => 3.00, :clearance => false}},
		{"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
		{"ALMONDS" => {:price => 9.00, :clearance => false}},
		{"TEMPEH" => {:price => 3.00, :clearance => true}},
		{"CHEESE" => {:price => 6.50, :clearance => false}},
		{"BEER" => {:price => 13.00, :clearance => false}},
		{"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
		{"BEETS" => {:price => 2.50, :clearance => false}}
	]
end

def coupons
	[
		{:item => "AVOCADO", :num => 2, :cost => 5.00},
		{:item => "BEER", :num => 2, :cost => 20.00},
		{:item => "CHEESE", :num => 3, :cost => 15.00}
	]
end

def generate_cart
	[].tap do |cart|
		rand(20).times do
			cart.push(items.sample)
		end
	end
end

def generate_coupons
	[].tap do |c|
		rand(2).times do
			c.push(coupons.sample)
		end
	end
end

cart = generate_cart
coupons = generate_coupons

###################################################################
def consolidate_cart(cart) # consolidate_cart - method (return organize cart with counts)
  cart_consolidated = {}
  cart.each{|item|
  name = item.keys.first
  if cart_consolidated[name] == nil 
    cart_consolidated[name] = item[name]
    cart_consolidated[name][:count] = 1
  else
    cart_consolidated[name][:count] += 1
  end
  }
cart_consolidated
end

def apply_coupons(cart, coupons_a) ## cart & coupons to be apply
  coupons_a.each{|coupon|
  coupon_name = coupon[:item]
  if cart[coupon_name] && cart[coupon_name][:count] >= coupon[:num]
    cart[coupon_name][:count] -= coupon[:num]
    #if cart[coupon_name][:count] == 0
    #  cart.delete(coupon_name)
    #end # need fix
    cart["#{coupon_name} W/COUPON"] ={ price: ((coupon[:cost]/coupon[:num]).round(2)), clearance: (cart[coupon_name][:clearance]), count: coupon[:num]}
  end
  }
  cart
end

def apply_clearance(cart)
cart.each{|item, cart_key|
  if cart_key[:clearance]
    cart_key[:price] = (cart_key[:price] * 0.8).round(2)
  end
}
cart
end

def checkout(cart, coupons)
final_cart = consolidate_cart(cart)
final_cart = apply_coupons(final_cart, coupons)
final_cart = apply_clearance(final_cart)
cart_total = 0
final_cart.each{|item, key|
  cart_total += key[:price]*key[:count].round(2)
}
return (cart_total*0.9).round(2) if cart_total > 100
cart_total
end

###################################################################
puts "Items in cart"
cart.each do |item|
	puts "Item: #{item.keys.first}"
	puts "Price: #{item[item.keys.first][:price]}"
	puts "Clearance: #{item[item.keys.first][:clearance]}"
	puts "=" * 10
end

puts "Coupons on hand"
coupons.each do |coupon|
	puts "Get #{coupon[:item].capitalize} for #{coupon[:cost]} when you by #{coupon[:num]}"
end

puts "Your total is #{checkout(cart: cart, coupons: coupons)}"