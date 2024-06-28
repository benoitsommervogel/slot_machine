require "json"
require "slot_machine/services/calendar_stub"
require "slot_machine/models/calendar"

module SlotMachine
	class User
		def initialize(name)
			@name = name
			@calendar = SlotMachine::Calendar.new(name)
		end

		def get_avalaible_slots(start_date, end_date, duration)
			return @calendar.get_available_slots(start_date, end_date, duration)
		end
	end
end