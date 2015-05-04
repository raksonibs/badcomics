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
      hostname = request.original_url || "http://badcomics.ca" 
      BadMailer.intro_email(@subscriber, hostname).deliver
      flash[:notice] = "You are signed up noob!"
      #  shouldn't redirect, should be ajax request
      redirect_to :root
    else
      binding.pry
      flash[:notice] = "Put an actual email ya goof!"
      render :new
    end

  end

  def unsubcribe
    # Should I have two factor unsubscribe. Like are your sure you want to do this? With something funny. I tihnk so! Like pictures of us as children, and then it is saying if you unsubcribe, you kill the hopes and dreams of all these children. Make it really hard. ha.
    @subscriber = Subscriber.find(params[:subscriber_id])
  end

  def unsubscribe_confirm
    # begin
      @subscriber = Subscriber.find(params[:subscriber_id])
      @subscriber.subscribed = false
      flash[:notice] = "Fine you unsubscribed asshole"
      redirect_to :root
    # rescue
      # flash[:notice] = "You tricky mixy you. There is no subscriber like that"
      # redirect_to :root
    # end
  end

  private
    def subscriber_params
      params.require(:subscriber).permit(:email, :subscribed, :intro_sent)
    end
end
