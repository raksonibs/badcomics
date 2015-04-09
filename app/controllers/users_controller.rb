class UsersController < ApplicationController
  # before_filter :require_login, only: [:home]

  def new
    @user = User.new
  end

  def prev
    @image = User.prevImage(Image.find(params[:current]))
    render :normal
  end

  def next
    @image = User.nextImage(Image.find(params[:current]))
    render :normal
  end

  def first
    @image = User.firstImage
    render :normal
  end

  def past
    @images = User.allImages
  end

  def random
    @image = User.allImages.sample
    render :normal
  end

  def normal
    @image = User.latestImage
  end

  def home
    @user = current_user
  end

  def upload    
    @user = current_user
    if @user.save
     # params[:avatar] will be an array.
     # you can check total number of photos selected using params[:avatar].count
      params[:user][:comic].each do |picture|      

        @user.images.create(:comic=> picture)
        # Don't forget to mention :avatar(field name)

      end      
      redirect_to :root
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
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :country_code, :phone_number)
    end
end
