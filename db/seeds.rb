Event.destroy_all

contents = File.read('eventsseedfile.txt')
eventAll = []
contents = contents[1..-2]
eventSeed = Array(contents).flatten
count = 0 
puts 'Creating Events from Seedfile'
contents.split(/\{/).each_with_index do |event, index|
  symbolData = event.split('", ')
  tmpEvent = Event.new()
  symbolData.each do |attribute|
    syms = attribute.split('=>')
    syms[1] = Array(syms[1]) if syms[0] == ':categoryList'
    syms[0] = ':url' if syms[0] == ':eventUrl'
    tmpEvent.update_attributes({
      syms[0].gsub(':', '') => syms[1]
    })
  end
  tmpEvent.save!
end