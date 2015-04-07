module ApplicationHelper
<<<<<<< HEAD
	def attracts
		info={}
		#price(nonexistant), category, address
		oo=Roo::Excel.new("places_of_attraction.xls")
		(oo.last_row-1).times do |i|
			info[oo.cell(i+2,"F")]=["Need price for each place", oo.cell(i+2, "J"), oo.cell(i+2,"C")]
		end
	end
=======
>>>>>>> 6721de769c2e5cfebde11d8b6c385461dda1287d
end
