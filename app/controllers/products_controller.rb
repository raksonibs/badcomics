class ProductsController < ApplicationController
  def new
  end

  def create
    @product = Product.create(product_params)
    @product.product_image = params[:product][:product_image] unless params[:product][:product_image].nil?
    if @product.save()
     # params[:avatar] will be an array.
     # you can check total number of photos selected using params[:avatar].count  
      redirect_to home_path(current_user.id)
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    @product.product_image = params[:product][:product_image] unless params[:product][:product_image].nil?

    if @product.update(product_params)
      render :edit
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to home_path(current_user.id)
  end

  private
  def product_params
    params.require(:product).permit(:name, :price, :description, :image_url, :product_image)
  end
end
