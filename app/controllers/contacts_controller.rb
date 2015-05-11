class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      respond_to do |format|
        format.js {}
        format.html {redirect_to :root}
      end
    else
      flash.now[:error] = 'Cannot send message.'
      render :new
    end
  end
end
