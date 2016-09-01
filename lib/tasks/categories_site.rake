namespace :categories do
	desc "Creates the configuration for default kitchen"
	task :escondida => [:environment] do
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
      ].each_with_index do |i,cat|
        ProductFamily.create(name: cat, image: '/images/product_families/1.png', order: i+1)
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
end