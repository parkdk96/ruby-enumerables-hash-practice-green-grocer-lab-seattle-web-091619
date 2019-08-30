def consolidate_cart(cart)
  # code here
  cart_hash = {}
  cart.each do |item_hash|
    item_hash.each do |item_key, item_val|
      if !cart_hash.key?(item_key)
        cart_hash[item_key] = item_val
        cart_hash[item_key][:count] = 1
      else
        cart_hash[item_key][:count] += 1
      end
    end
  end
  return cart_hash
end

def apply_coupons(cart, coupons)
  cart.clone.each do |item, specs|
    # need to make a clone in order to avoid adding a new key into hash during iteration error
    coupons.length.times do |i|
      if item.to_s == coupons[i][:item].to_s
        # conditional for the case where there is more than one coupon for the same item
        if cart.include?("#{item.to_s} W/COUPON")
          cart["#{item.to_s} W/COUPON"][:count] += coupons[i][:num].to_i
          specs[:count] = specs[:count].to_i - coupons[i][:num].to_i
        else
          discounted_item = "#{item.to_s} W/COUPON"
          remaining_items = specs[:count].to_i - coupons[i][:num].to_i
          discounted_price = coupons[i][:cost].to_f / coupons[i][:num].to_f
          cart[discounted_item] = {
            :price => discounted_price,
            :clearance => specs[:clearance],
            :count => coupons[i][:num].to_i
            }
          specs[:count] = remaining_items
        end
      end
    end
  end
  return cart
end

def apply_clearance(cart)
  cart.each do |item, specs|
    if specs[:clearance]
      specs[:price] = (0.8 * specs[:price].to_f).round(2)
    end
  end
  return cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  discounted_cart = apply_coupons(consolidated_cart, coupons)
  clearance_cart = apply_clearance(discounted_cart)
  
  total = 0 
  
  clearance_cart.each do |item, specs|
    total += specs[:price].to_f * specs[:count].to_f
  end
  
  if 100 < total
    total *= 0.9
  end
  return total
end




