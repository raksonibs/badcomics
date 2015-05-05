class ImagesController < ApplicationController
  def edit
  end

  def update
    @image = Image.find(params[:id])
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy!
    redirect_to home_path(current_user)
  end
end
