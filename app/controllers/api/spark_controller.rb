class Api::SparkController < ApplicationController
  respond_to :json

  before_action :set_wrapper

  def replay    
    @number_of_companies = @wrapper.replay
    respond_with @number_of_companies
  end

  private
  def set_wrapper
    @wrapper = ApiWrapper.new()
  end

end
