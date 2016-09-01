namespace :categories do
	desc "Creates the configuration for default kitchen"
	task :escondida_products => [:environment] do
    [
      'Entradas',
      'Fuertes',
      'Almuerzos',
      'Hamburguesas',
      'Postres',
      'Cocktails',
      'Licores',
      'Cervezas',
      'Gaseosas',
      'Jugos'
      ].each_with_index do |cat,i|
        ProductFamily.create(name: cat, image: '/images/product_families/1.png', order: i+1)
    end
  end
  task :escondida_supplies => [:environment] do
    [
      'Verduras y Legumbres',
      'Carnes',
      'Quesos',
      'Pulpas de Fruta',
      'Embotellados',
      'Procesados',
      'Otros'
    ].each do |cat|
      SupplyCategory.create(name: cat, image: '/images/supply_categories/1.png')
    end
  end
end