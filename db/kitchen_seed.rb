if Kitchen.all.empty?
	k = Kitchen.create(name: "default", short_name: "d", description: "default")
	Product.all.each do |d|
		d.kitchens << k
		d.save!
	end
	User.all.each do |u|
		u.kitchens << k
		u.save
	end
end