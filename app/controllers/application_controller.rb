class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def attracts
		info={}
		#price(nonexistant), category, address
		oo=Roo::Excel.new("places_of_attraction.xls")
		(oo.last_row-1).times do |i|
			info[oo.cell(i+2,"F")]=["Need price for each place", oo.cell(i+2, "J"), oo.cell(i+2,"C")]
		end
		info
	end
end
