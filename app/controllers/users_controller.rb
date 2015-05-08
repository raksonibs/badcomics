class UsersController < ApplicationController
  before_filter :authenticate!, only: [:home]
  before_filter :set_subscriber

  def new
    @user = User.new
  end

  def zoho
  end

  def prev
    @image = User.prevImage(Image.find(params[:current]))
    render :normal
  end

  def next
    @image = User.nextImage(Image.find(params[:current]))
    render :normal
  end

  def contact
  end

  def twofactor
    flash.now[:alert] = 'Two factor set up correctly'
    redirect_to :root
  end

  def first
    @image = User.firstImage
    render :normal
  end

  def past
    @images = User.allPublishedImages
  end

  def random
    @image = Image.find(params[:id])
    render :normal
  end

  def normal
    @image = User.latestImage
  end

  def error_404
    # render status: :not_found
  end

  def error_us
  end

  def error_422
  end

  def publish
    @image = Image.find(params[:image_id])
    @image.published = true
    @image.save!
    redirect_to :home
  end

  def unpublish
    @image = Image.find(params[:image_id])
    @image.published = false
    @image.save!
    redirect_to :home
  end

  def save_order
    images = params[:images]
    images.each do |i|
      splitStr = i.split(" = ")
      img = Image.find(splitStr[0].strip())
      img.order = splitStr[1].strip().to_i
      img.save!
    end
    redirect_to home_url(current_user)
  end

  def showtitle
    @user = current_user
    @image = Image.find(params[:image_id])
    @image.show_title = true
    @image.save!
    redirect_to :home
  end

  def unshowtitle
    @user = current_user
    @image = Image.find(params[:image_id])
    @image.show_title = false
    @image.save!
    redirect_to home_url(@user.id)
  end

  def home
    @images = current_user.images.order(:order)
    @user = current_user
  end

  def upload    
    @user = current_user
    if @user.save
     # params[:avatar] will be an array.
     # you can check total number of photos selected using params[:avatar].count
      params[:user][:comic].each do |picture|      

        @user.images.create(:comic=> picture, title: params[:user][:image][:title])
        # Don't forget to mention :avatar(field name)

      end      
      redirect_to :home
    end
  end

  def create
    @user = User.new(params[:user_params])
    @user.password = params[:password]

    if params[:user][:name] == Figaro.env.username && params[:user][:password] == Figaro.env.password
      if @user.save
        session[:user] = @user.id
        redirect_to root_url
      else
        render :new
      end
    else
      @user.errors.add(:password, 'Either username or password is incorrect')
      render :new
    end
  end

  def loginPage
  end

  def login
    # @user = User.find_by_name(params[:name])
    # if @user.password == params[:password]
    #   give_token
    # else
    #   redirect_to home_url
    # end
  end

  private

    def set_subscriber
      @subscriber = Subscriber.new
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :country_code, :phone_number)
    end
end
