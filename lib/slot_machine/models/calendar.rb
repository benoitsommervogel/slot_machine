require "json"
require "Time"
require "slot_machine/services/calendar_stub"
require "slot_machine/models/calendar_slot"

module SlotMachine
	class Calendar
		def initialize(name)
			# wanted to do a linked list but it would have taken me way more time to complete
			@first_slot = nil

			# not necessary for this exercise, but there may be cases in which interacting
			# directly with calendars (and not users) would be preferable (can a calendar be shared
			# with multiple users for example) in these situation, user should be accessible
			# I use the name as identifier for the purpose of this exercise
			@user_name = name
			fetch_calendar()
		end

		# I assume that we want the available slots for a time window
		# I could have decided that we wanted slots for a specific workday
		# But that's not the Way we tread (and that makes it a bit tougher)
		def get_available_slots(start_time, end_time, min_duration)
      return [] if @first_slot == nil
			empty_slots = []
			current_slot = CalendarSlot.new(start_time, start_time)
			starting_slot = @first_slot

			# we have to start with a slot that happens AFTER the beginning date
			# i lowkey hate this, I would love to find a better way but none cross my mind right now
			while starting_slot.start_time < Time.parse(start_time)
				starting_slot = starting_slot.next_slot
			end

			current_slot.next_slot = starting_slot
			while current_slot.next_slot != nil && current_slot.end_time < Time.parse(end_time)
        available = current_slot.get_available_slots_between(min_duration)
				empty_slots = empty_slots.concat(available)
				current_slot = current_slot.next_slot
			end
			return empty_slots
		end

    #for testing purpose
    def get_calendar_size
      return 0 if @first_slot == nil
      current_slot = @first_slot
      i = 1
      while current_slot.next_slot != nil
        i = i + 1
        current_slot = current_slot.next_slot
      end
      return i
    end

		private

		# We could add caching here if necessary
		def fetch_calendar
			get_calendar_service = SlotMachine::CalendarService::GetCalendar.new()
			current_slot = nil

			# and here comes unecessary complications for me but that's the Way it is.
			calendar_json = get_calendar_service.fetch(@user_name)

			# We are assuming that the api returns the date in order, if not this method will be
			# a bit more complex
      # Update : So that's what I get for juste glazing over the actual json file
      # I think i got exactly what I deserved
			calendar_json.each do |slot|
				# not great
				if @first_slot == nil
					@first_slot = SlotMachine::CalendarSlot.new(slot["start"], slot["end"])
					current_slot = @first_slot
				else
					current_slot.next_slot = SlotMachine::CalendarSlot.new(slot["start"], slot["end"])
					current_slot = current_slot.next_slot
				end
			end
		end
	end
end