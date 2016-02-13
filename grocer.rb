require 'pry'
def consolidate_cart(cart:[])

  new_hash = {}
  cart.each do |items|
    items.each do |name, details|
      if new_hash[name] == nil
        new_hash[name]= details.clone
        new_hash[name][:count] = 1
      else
      new_hash[name][:count] += 1
      end
    end
  end
  return new_hash

end


def apply_coupons(cart:[], coupons:[])
  new_cart = cart.clone
  coupons.each do |coupon|
    cart.each do |item, details|
      if item == coupon[:item]
        if new_cart["#{item} W/COUPON"] == nil && new_cart[item][:count] >= coupon[:num]
          new_cart[item][:count] = cart[item][:count] - coupon[:num]
          new_cart["#{item} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[item][:clearance], :count => 1}
        elsif new_cart["#{item} W/COUPON"] != nil && new_cart[item][:count] >= coupon[:num]
          new_cart[item][:count] -= coupon[:num]
          new_cart["#{item} W/COUPON"][:count] += 1
        end
      end
    end
    if new_cart == {}
      new_cart = cart
    end
  end
  return new_cart
end

def apply_clearance(cart:[])
  new_cart = {}
  cart.each do |item, details|
    if cart[item][:clearance] == true
      new_cart[item] = cart[item]
      new_cart[item][:price] = (cart[item][:price] * 0.8).round(2)
    else
      new_cart[item] = cart[item]
    end
  end
  return new_cart
end

def checkout(cart: [], coupons: [])

  new_cart = {}
  new_cart = consolidate_cart(cart: cart)
  new_cart = apply_coupons(cart: new_cart, coupons: coupons)
  new_cart = apply_clearance(cart: new_cart)
  total_price = 0
  new_cart.each do |item, details|
    total_price += new_cart[item][:price].to_f * new_cart[item][:count]
  end
  if total_price > 100
    total_price = (total_price * 0.9).round(2)
  end

  return total_price


end