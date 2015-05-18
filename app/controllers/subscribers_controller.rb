class SubscribersController < ApplicationController
  def new
    @subscriber = Subscriber.new
  end

  def create
    @subscriber = Subscriber.new(subscriber_params)
    @subscriber.subscribed = true
    # set delayjob for sending intro email?
    # at intro send for person, set subscriber.intro_sent = true

    @oldsub = Subscriber.find_by(email: @subscriber.email)

    respond_to do |format|
      if (!@oldsub.nil? && @oldsub.subscribed == false )|| @subscriber.save
        @subscriber = @oldsub.nil? ? @subscriber : @oldsub 
        @subscriber.subscribed = true
        @subscriber.save!

        hostname = request.original_url || "http://badcomics.ca" 
        BadMailer.intro_email(@subscriber, hostname).deliver
        flash[:notice] = "You are signed up noob!"
        # binding.pry
        format.html { redirect_to :root }
        format.json { render json: @subscriber }
        #  shouldn't redirect, should be ajax request
      else
        flash[:notice] = "This email is already subscribed!"
        # binding.pry
        format.html { render :new }
        format.json { render json: @subscriber.errors, status: :unprocessable_entity }
      end
    end

  end

  def unsubcribe
    # Should I have two factor unsubscribe. Like are your sure you want to do this? With something funny. I tihnk so! Like pictures of us as children, and then it is saying if you unsubcribe, you kill the hopes and dreams of all these children. Make it really hard. ha.
    @subscriber = Subscriber.find(params[:subscriber_id])
  end

  def unsubscribe_confirm
    begin
      @subscriber = Subscriber.find(params[:subscriber_id])
      @subscriber.subscribed = false
      @subscriber.save!
      flash[:notice] = "Fine you unsubscribed asshole"
      redirect_to :root
    rescue
      flash[:notice] = "You tricky mixy you. There is no subscriber like that"
      redirect_to :root
    end
  end

  private
    def subscriber_params
      params.require(:subscriber).permit(:email, :subscribed, :intro_sent)
    end
end
