require "json"
require "slot_machine/services/calendar_stub"
require "slot_machine/models/calendar_slot"
require "slot_machine/models/common/utils"

module SlotMachine
	class Calendar

    include SlotMachine::Utils

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
			last_slot = CalendarSlot.new(end_time, end_time)
			starting_slot = @first_slot

			# we have to start with a slot that happens AFTER the beginning date
			# i lowkey hate this, I would love to find a better way but none cross my mind right now
			while starting_slot.start_time < Time.parse(start_time)
				starting_slot = starting_slot.next_slot
			end

			current_slot.next_slot = starting_slot
      temporary_overlaping_slot = nil

			while current_slot.next_slot != nil && current_slot.next_slot.start_time < Time.parse(end_time)
        # this condition was not part of the initial plan
        # it is triggered if we previously noticed a slot that overlap with slots
        # stored afterwards in the linked list
        if temporary_overlaping_slot != nil
          temporary_overlaping_slot.next_slot = current_slot.next_slot
          available = temporary_overlaping_slot.get_available_slots_between(min_duration)
          temporary_overlaping_slot = nil if temporary_overlaping_slot.end_time < current_slot.next_slot.end_time
        else
          # this one was originaly the only code used to get free slots
          available = current_slot.get_available_slots_between(min_duration)
        end
				empty_slots = empty_slots.concat(available)

        # We have to make the progression a bit more complex to handle messy schedules
        # (see the lucifer file) I now understand it's out of the exercise premise but I got 80%
        # of the way in without realizing it
        # This is how we skip the overlapping slots that might mess with the
        # free space, we store the current (and overlaping) slot in a temporary slot to be used as
        # a reference until there is no anomaly anymore
        if current_slot.next_slot != nil && current_slot.end_time > current_slot.next_slot.end_time
          temporary_overlaping_slot = CalendarSlot.new(current_slot.start_time.to_s, current_slot.end_time.to_s)
        end

        current_slot = current_slot.next_slot
			end

      # dirty, i did not think this specific case through
      empty_slots = empty_slots.concat(current_slot.get_available_slots_before(min_duration, Time.parse(end_time)))

			return empty_slots
		end

    #for testing purpose
    def get_slot_array
      array = []
      return array if @first_slot == nil
      current_slot = @first_slot
      while current_slot.next_slot != nil
        array.push(current_slot.start_time.to_s)
        current_slot = current_slot.next_slot
      end
      array.push(current_slot.start_time.to_s)
      return array
    end

		private

		# We could add caching here if necessary
		def fetch_calendar
			get_calendar_service = SlotMachine::CalendarService::GetCalendar.new()

			# and here comes unecessary complications for me but that's the Way it is.
			calendar_json = get_calendar_service.fetch(@user_name)

			# We are assuming that the api returns the date in order, if not this method will be
			# a bit more complex
      # Update : So that's what I get for juste glazing over the actual json file
      # I think i got exactly what I deserved, so we order them while creating
      # IT DOES NOT SOLVE THE OVERLAP ISSUE so we'll have to skip the overlaps later
      # while searching for available slots
			calendar_json.each do |slot|
        new_slot = SlotMachine::CalendarSlot.new(slot["start"], slot["end"])
				if @first_slot == nil || @first_slot.start_time > new_slot.start_time
          new_slot.next_slot = @first_slot
          @first_slot = new_slot
				else
          current_slot = @first_slot
          while current_slot.next_slot != nil && current_slot.next_slot.start_time < new_slot.start_time do
            current_slot = current_slot.next_slot
          end
          new_slot.next_slot = current_slot.next_slot
					current_slot.next_slot = new_slot
				end
			end
		end
	end
end