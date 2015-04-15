class SubscribersController < ApplicationController
  def new
    @subscriber = Subscriber.new
  end

  def create
    @subscriber = Subscriber.new(params[:subscriber_params])
    if @subscriber.save
      flash[:notice] = "You are signed up noob!"
      redirect_to :root
    else
      flash[:notice] = "Put an actual email ya goof!"
      render :new
    end

  end

  def destroy
  end

  private
    def subscriber_params
      params.require(:subscriber).permit(:email)
    end
end
