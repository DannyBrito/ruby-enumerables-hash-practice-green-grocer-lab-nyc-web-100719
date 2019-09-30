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
    if cart["#{coupon_name} W/COUPON"]
    cart["#{coupon_name} W/COUPON"][:count] += coupon[:num]
    else  
    cart["#{coupon_name} W/COUPON"] ={ price: ((coupon[:cost]/coupon[:num]).round(2)), clearance: (cart[coupon_name][:clearance]), count: coupon[:num]}
    end
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