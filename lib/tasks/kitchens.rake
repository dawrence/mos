namespace :kitchens do
	desc "Creates the configuration for default kitchen"
	task :initialize => [:environment] do
		c = Kitchen.create(name: "Cocina", short_name:"C", description:"Cocina default")
		MenuProduct.all.each do |p|
			p.product.update_attributes!(product_kitchens_attributes:[
					{
						kitchen_id: c.id,
						product_id: p.product.id
					}
				])
		end
		User.all.each do |u|
			u.kitchens << c
			u.save
		end
	end
end