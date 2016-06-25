require 'test_helper'

class ProductTest < ActiveSupport::TestCase

	test "equal"  do
		assert products(:p_6).equal_with(products(:p_7)), "#{products(:p_7).menu_product_id}, #{products(:p_7).price} | #{products(:p_6).menu_product_id}, #{products(:p_6).price}" 
	end

	test "not_equal_by_different_ingredient_quantity" do
		assert !products(:p_6).equal_with(products(:p_8))
	end

	test "not_equal_by_different_supply" do
		assert !products(:p_6).equal_with(products(:p_9))
	end

	test "not_equal_by_different_ingredients_length" do
		assert !products(:p_6).equal_with(products(:p_10))
	end

	test "not_equal_by_price" do
		assert !products(:p_6).equal_with(products(:p_11))
	end

	test "not_equal_by_menu_product_id" do
		assert !products(:p_6).equal_with(products(:p_12))
	end

	test "compare_to_null" do
		assert !products(:p_1).equal_with(nil)
	end

	test "make_original" do
		products(:p_2).make_original()
		assert products(:p_2).original and not products(:p_2).original_copy
	end

	test "make_original_copy" do
		products(:p_2).make_original_copy()
		assert (not products(:p_2).original ) and products(:p_2).original_copy
	end

end
