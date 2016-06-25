def test_bills(bills_ids)
	Bill.includes([orders: {product: {additionals: :additional}}]).where(id: bills_ids).each do |b|
		b.orders.each do |o|
			if o.product
				if not o.unit_price == o.product.price
					puts "Order #{o.id} #{o.bill_id} #{o.product_id} fails"
				else
					if o.product.additionals
						o.product.additionals.each do |a|
							if not a.unit_price == a.additional.price
								puts " additional #{a.id} #{a.additional_id} #{a.product_id} fails"
							end
						end
					end
				end

			end
		end
	end
end

test_bills([50940,50941,50942,50943])