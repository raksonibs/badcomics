module UsersHelper
  def setup_user(user)
    user.image ||= Image.new
    user
  end
end
