class MenuProductsController < ApplicationController
  # GET /menu_products
  # GET /menu_products.json
  def privileges
    [{generic: [:product_management]}]
  end


  def index
    @product_families = ProductFamily.includes([menu_products: [{product: :quantifiable_ingredients}]]).all
    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @menu_products }
    end
  end

  # GET /menu_products/1
  # GET /menu_products/1.json
  def show
    @menu_product = MenuProduct.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @menu_product }
    end
  end

  # GET /menu_products/new
  # GET /menu_products/new.json
  def new
    @product_family = ProductFamily.find(params[:pf_id])
    @menu_product = @product_family.menu_products.new
    @product = @menu_product.products.build
    @supply_categories = SupplyCategory.includes(:supplies).all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @menu_product }
    end
  end

  # GET /menu_products/1/edit
  def edit
    @menu_product = MenuProduct.includes([product: :ingredients]).find(params[:id])
    @product = @menu_product.product
    @supply_categories = SupplyCategory.includes(:supplies).all
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @menu_product }
    end
  end

  # POST /menu_products
  # POST /menu_products.json
  def create  
    @menu_product = MenuProduct.new(params[:menu_product])
    @menu_product.products.first.original = true   
    ingredients = []

    @menu_product.products.first.ingredients.each do |i|      
      ingredients += [i] unless i.quantity == 0 
    end
    @menu_product.products.first.ingredients = ingredients
    respond_to do |format|
      if @menu_product.save
        format.html { redirect_to menu_products_path, notice: 'Menu product was successfully created.' }
        format.json { render json: @menu_product, status: :created, location: @menu_product }
      else
        @product = @menu_product.products.build
        @supply_categories = SupplyCategory.includes(:supplies).all
        format.html { render action: "new" }
        format.json { render json: @menu_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /menu_products/1
  # PUT /menu_products/1.json
  def update
    @menu_product = MenuProduct.includes([product: :ingredients]).find(params[:id])
    ingredients = []

    params[:menu_product][:products_attributes]["0"][:ingredients_attributes].each do |i|
      ingredients += [i] unless i[:quantity].to_f == 0 
    end

    product= Product.create!(price: params[:menu_product][:products_attributes]["0"][:price], ingredients_attributes:  ingredients, 
      product_kitchens_attributes: params[:menu_product][:products_attributes]["0"][:product_kitchens_attributes])
    respond_to do |format|
      if @menu_product.update_with(product,params[:menu_product])        
        format.html { redirect_to menu_products_path, notice: 'Menu product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @menu_product.errors, status: :unprocessable_entity }
      end
    end
  
  end

  # DELETE /menu_products/1
  # DELETE /menu_products/1.json
  def destroy
    @menu_product = MenuProduct.find(params[:id])
    @menu_product.destroy

    respond_to do |format|
      format.html { redirect_to menu_products_url }
      format.json { head :no_content }
    end
  end

end
