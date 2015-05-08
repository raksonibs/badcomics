class ImagesController < ApplicationController
  before_filter :set_subscriber

  def edit
    @image = Image.find(params[:id])
  end

  def update
    @image = Image.find(params[:id])
    @image.comic = params[:image][:comic] unless params[:image][:comic].nil?

    if @image.update(image_params)
      render :edit
    else
      render :edit
    end
  end

  def show
    @image = Image.friendly.find(params[:id])
    if @image.published?
      # redirect_to @image
    else
      redirect_to normal_path
    end
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy!
    redirect_to home_path(current_user)
  end

  private
  def set_subscriber
    @subscriber = Subscriber.new
  end

  def image_params
    params.require(:image).permit(:title, :large_img)
  end
end
