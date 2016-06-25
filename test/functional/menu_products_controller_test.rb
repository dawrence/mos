require 'test_helper'

class MenuProductsControllerTest < ActionController::TestCase
  setup do
    @menu_product = menu_products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:menu_products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create menu_product" do
    assert_difference('MenuProduct.count') do
      post :create, menu_product: { description: @menu_product.description, name: @menu_product.name, product_family_id: @menu_product.product_family_id }
    end

    assert_redirected_to menu_product_path(assigns(:menu_product))
  end

  test "should show menu_product" do
    get :show, id: @menu_product
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @menu_product
    assert_response :success
  end

  test "should update menu_product" do
    put :update, id: @menu_product, menu_product: { description: @menu_product.description, name: @menu_product.name, product_family_id: @menu_product.product_family_id }
    assert_redirected_to menu_product_path(assigns(:menu_product))
  end

  test "should destroy menu_product" do
    assert_difference('MenuProduct.count', -1) do
      delete :destroy, id: @menu_product
    end

    assert_redirected_to menu_products_path
  end
end
