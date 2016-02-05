class Api::V1::ComicsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  def index
    @comics = Image.all
    respond_with @comics
  end
end