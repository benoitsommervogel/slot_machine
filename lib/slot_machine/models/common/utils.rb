require "time"

module SlotMachine
	module Utils
		def start_workday(date)
			return DateTime.new(date.year, date.month, date.day, 9, 0, 0, date.zone).to_s
		end

		def end_workday(date)
			return DateTime.new(date.year, date.month, date.day, 18, 0, 0, date.zone).to_s
		end
	end
end