class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    BadMailer.contact_to_us(@contact).deliver
    if @contact.deliver
      respond_to do |format|
        format.js {}
        format.html {redirect_to :root}
        # flash.now[:notice] = 'Thanks for contacting us. It better be good.'
        # redirect_to root_url
      end
    else
      flash.now[:error] = 'Cannot send message.'
      render :new
    end
  end

  def contact_us
  end
end
