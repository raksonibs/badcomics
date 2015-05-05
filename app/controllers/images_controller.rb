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
    params.require(:image).permit(:title)
  end
end
