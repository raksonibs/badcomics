class Api::SparkController < ApplicationController
  respond_to :json

  before_action :set_wrapper

  def replay
    @result = @wrapper.replay
    respond_with @result
  end

  private
  def set_wrapper
    @wrapper = ApiWrapper.new()
  end

end
