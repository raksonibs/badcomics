json.price @cart.products.map(&:price).inject(0){ |sum, i| sum + i }.to_f
json.item_count @cart.products.count