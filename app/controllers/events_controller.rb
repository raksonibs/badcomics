class EventsController < ApplicationController
	def show
		@event=Event.find_by_id(params[:event_id])
		respond_to do |format|
			format.js{ render :action => "event.js.erb" }
		end
	end
end
