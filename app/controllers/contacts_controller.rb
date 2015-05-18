class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    if @contact.valid?
      BadMailer.contact_to_us(@contact).deliver
      respond_to do |format|
        format.js {}
        format.html { redirect_to :root }
      end
    else
      format.js { render json: @contact.errors, status: :unprocessable_entity }
      format.html { render :new }
    end
  end

  def contact_us
  end
end
