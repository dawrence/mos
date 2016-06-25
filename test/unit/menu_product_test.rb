require 'test_helper'

class MenuProductTest < ActiveSupport::TestCase
    test "update_menu_product" do
		mp1=menu_products(:mp_1)
		p2 = Product.create(price: 1000, ingredients_attributes: [{supply_id: supplies(:s_1).id}, {supply_id: supplies(:s_2).id}, {supply_id: supplies(:s_3).id}], menu_product_id: mp1.id, original: false)
		mp1.update_with(p2)
		assert MenuProduct.find(p2.menu_product_id).product.equal_with(p2)
	end

	test "check_original" do
		mp1=menu_products(:mp_2)
		p1 = mp1.product
		p2 = Product.create(price: 1000, ingredients_attributes: [{supply_id: supplies(:s_1).id}, {supply_id: supplies(:s_2).id}, {supply_id: supplies(:s_3).id}], menu_product_id: mp1.id, original: false)
		mp1.update_with(p2)
		assert (MenuProduct.find(p2.menu_product_id).product.original and not p1.original), "#{mp1.product.original} #{p1.original}"
	end

	test "check_original_copy" do
		mp1= menu_products(:mp_2)
		p1 = mp1.product
		p2 = Product.create(price: 2000, ingredients_attributes: [{supply_id: supplies(:s_1).id}, {supply_id: supplies(:s_2).id}, {supply_id: supplies(:s_3).id}], original: false)
		mp1.update_with(p2)
		assert p1.original_copy and not p1.original
	end

	test "check_equality" do		
		mp1=menu_products(:mp_3)
		p1 = mp1.product
		p2 = p1
		mp1.update_with(p2)
		as1 = mp1.product
		mp1.update_with(p1)
		as2 = mp1.product
		assert as1.equal_with(as2)
    end

    test "check_menu_product" do
    	mp1=menu_products(:mp_2)
		p2 = Product.create(price: 1000, ingredients_attributes: [{supply_id: supplies(:s_1).id}, {supply_id: supplies(:s_2).id}, {supply_id: supplies(:s_3).id}], original: false)
		mp1.update_with(p2)
		assert mp1.id == Product.find(p2.id).menu_product_id
    end

    test "check_menu_product_copy" do
    	mp1= menu_products(:mp_2)
    	p1 = mp1.product
		p2 = Product.create(price: 1000, ingredients_attributes: [{supply_id: supplies(:s_1).id}, {supply_id: supplies(:s_2).id}, {supply_id: supplies(:s_3).id}], original: false)
		mp1.update_with(p2)
		assert mp1.id == Product.find(p1.id).menu_product_id, "fuck failed #{p1.id}, #{p1.menu_product_id}"
    end
end
