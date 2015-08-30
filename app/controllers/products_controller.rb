class ProductsController < ApplicationController
  def new
  end

  def create
    @product = Product.create(product_params)
    # @product.product_image = params[:product][:product_image] unless params[:product][:product_image].nil?
    # binding.pry
    if @product.save()
      params[:product][:product_image].each do |picture|      

        @product.product_images.create(:store_image=> picture)
        # Don't forget to mention :avatar(field name)

      end      
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

    if @product.update_attributes(product_params)
      unless params[:product][:product_image].nil?
        @product.product_images.destroy_all
        params[:product][:product_image].each do |picture|      
          @product.product_images.create(:store_image=> picture)
        end
      end
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
