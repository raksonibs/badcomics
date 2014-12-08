every :tuesday, :at=> "04:00am" do
	rake "get_events:get_events"
end

# every :hour do
#   rake "run_print:run_print"
# end
