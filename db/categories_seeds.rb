# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ProductFamily.delete_all

ProductFamily.create(name: 'Hamburguesas', image: '/images/product_families/1.png', order: 1)

ProductFamily.create(name: 'Perros', image: '/images/product_families/2.png', order: 2)

ProductFamily.create(name: 'Arepas', image: '/images/product_families/3.png', order: 3)

ProductFamily.create(name: 'Chuzos', image: '/images/product_families/4.png', order: 4)

ProductFamily.create(name: 'Otros', image: '/images/product_families/5.png', order: 5)

ProductFamily.create(name: 'Gaseosas', image: '/images/product_families/6.png', order: 6)

ProductFamily.create(name: 'Cervezas', image: '/images/product_families/7.png', order: 7)

ProductFamily.create(name: 'Granizados', image: '/images/product_families/8.png', order: 8)

ProductFamily.create(name: 'Jugos', image: '/images/product_families/9.png', order: 9)

ProductFamily.create(name: 'Adicionales', image: '/images/product_families/10.png', additional_family: true, order: 10)

SupplyCategory.delete_all

SupplyCategory.create(name: 'Frutas, Verduras y Vegetales', image: '/images/supply_categories/1.png')

SupplyCategory.create(name: 'Carnes', image: '/images/supply_categories/2.png')

SupplyCategory.create(name: 'Panes y Arepas', image: '/images/supply_categories/3.png')

SupplyCategory.create(name: 'Salsas', image: '/images/supply_categories/4.png')

SupplyCategory.create(name: 'Embotellado', image: '/images/supply_categories/5.png')

SupplyCategory.create(name: 'Lacteos', image: '/images/supply_categories/6.png')

SupplyCategory.create(name: 'Otros', image: '/images/supply_categories/7.png')
