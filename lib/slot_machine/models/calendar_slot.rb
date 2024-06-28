# Was another file REALLY necessary ? I prefer it that way in any case
require "time"

# So this class is pretty empty as is, but in most situations, slots will contain
# descriptions, participants, locations etc, etc
# A class is in order.

module SlotMachine
	class CalendarSlot
    attr_accessor :start_date, :end_date, :previous_slot, :next_slot

    # I had the brilliant idea of making EMPTY slots initially that
    # I would diretcly fetch
    # And then I realized that it would be hell to implement so nope
		def initialize(start_time, end_time, previous_slot)
      # Error handling non existent IT'S A SIN
      @start_time = Time.new(start_date)
      @end_time = Time.new(end_time)

      # THAT'S RIGHT, WE'RE MAKING A LINKED LIST BABY !
      @next_slot = nil
		end


    def get_available_slots_between(min_duration)
      if next_slot != nil && @next_slot.start_time.wday == @end_time.wday
        return available_slots_between(self, @next_slot)
      elsif next_slot != nil 
        # here we find the available slots between two slots not on the same day
        # I hate it
        end_of_day = Utils::end_workday(@end_time)
        start_tomorrow = Utils::start_workday(@next_slot.start_time)
        return available_slots_between(self, CalendarSlot.new(end_of_day, end_of_day)) + available_slots_between(CalendarSlot.new(start_tomorrow, start_tomorrow), @next_slot)
      end
      return []
    end

    private
    def available_slots_between(first_slot, second_slot)
      available_slots = []
      free_window = ((first_slot.start_time - second_slot.end_time) / 3600) - min_duration
      # we can start a slot at any hour, so for each hour above our limit
      # it's an extra slot
      for i in 0..free_window
        available_slots.push(@end_time + (i * 3600))
      end
      return available_slots
    end
	end
end