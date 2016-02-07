require 'pry'

def consolidate_cart(cart:[])
  cart.each_with_object({}) do |each_cart, new_cart|
    each_cart.each do |item, info|
      new_cart[item] ||= info
      new_cart[item][:count] ||= 0
      new_cart[item][:count] += 1
    end
  end
end

def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
    if cart[coupon[:item]] and cart[coupon[:item]][:count] >= coupon[:num]
      cart[coupon[:item]][:count] -= coupon[:num]
      cart["#{coupon[:item]} W/COUPON"] ||= {
        price: coupon[:cost],
        clearance: cart[coupon[:item]][:clearance],
        count: 0
      }
      cart["#{coupon[:item]} W/COUPON"][:count] += 1
    end
  end
  cart
end

def apply_clearance(cart:[])
  cart.each do |item, info|
    if info[:clearance]
      cart[item][:price] = (cart[item][:price] * 0.8).round(1)
    end
  end
end

def checkout(cart:[], coupons:[])
  final_cart = consolidate_cart(cart: cart)
  final_cart = apply_coupons(cart: final_cart, coupons: coupons)
  final_cart = apply_clearance(cart: final_cart)
  total_cost = 0
  final_cart.each do |item, info|
    total_cost += (info[:price] * info[:count])
  end
  total_cost = (total_cost * 0.9).round(1) if total_cost > 100
  return total_cost
end