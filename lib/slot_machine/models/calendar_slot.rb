# Was another file REALLY necessary ? I prefer it that way in any case
require "time"
require "slot_machine/models/common/utils"

# So this class is pretty empty as is, but in most situations, slots will contain
# descriptions, participants, locations etc, etc
# A class is in order.

module SlotMachine
	class CalendarSlot
    include SlotMachine::Utils
    attr_accessor :start_time, :end_time, :next_slot

    # I had the brilliant idea of making EMPTY slots initially that
    # I would diretcly fetch
    # And then I realized that it would be hell to implement so nope
		def initialize(start_time, end_time)
      # Error handling non existent IT'S A SIN

      @start_time = Time.parse(start_time) unless start_time.nil?
      @end_time = Time.parse(end_time) unless end_time.nil?

      # THAT'S RIGHT, WE'RE MAKING A LINKED LIST BABY !
      # update : probably a mistake :(
      # update n°2 : it was a big mistake
      @next_slot = nil
		end


    def get_available_slots_between(min_duration)
      if next_slot != nil && @next_slot.start_time.wday == @end_time.wday
        return available_slots_between(self, @next_slot, min_duration)
      elsif next_slot != nil
        # here we find the available slots between two slots not on the same day
        # I hate it
        end_of_day = end_workday(@end_time)
        start_tomorrow = start_workday(@next_slot.start_time)
        return available_slots_between(self, CalendarSlot.new(end_of_day, end_of_day), min_duration) + available_slots_between(CalendarSlot.new(start_tomorrow, start_tomorrow), @next_slot, min_duration)
      end
      return []
    end

    private

    def available_slots_between(first_slot, second_slot, min_duration)
      available_slots = []
      free_window = ((second_slot.start_time - first_slot.end_time) / 3600) - min_duration
      # we can start a slot at any hour, so for each hour above our limit
      # it's an extra slot
      for i in 0..free_window
        available_slots.push(DateTime.new(first_slot.end_time.year, first_slot.end_time.month, first_slot.end_time.day, first_slot.end_time.hour + i, 0, 0, first_slot.end_time.zone).to_s)
      end
      return available_slots
    end
	end
end