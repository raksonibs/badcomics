class SubscribersController < ApplicationController
  def new
    @subscriber = Subscriber.new
  end

  def create
    @subscriber = Subscriber.new(subscriber_params)
    @subscriber.subscribed = true
    # set delayjob for sending intro email?
    # at intro send for person, set subscriber.intro_sent = true
    if @subscriber.save
      BadMailer.intro_email(@subscriber).deliver
      flash[:notice] = "You are signed up noob!"
      #  shouldn't redirect, should be ajax request
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
      params.require(:subscriber).permit(:email, :subscribed, :intro_sent)
    end
end
