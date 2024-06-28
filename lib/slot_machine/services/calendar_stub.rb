require "json"

module SlotMachine
	module CalendarService
		class GetCalendar

			def initialize
				#nothing here unfortunately in the context of the exercise
			end

			def fetch(user)
				begin
					file = File.open(File.join(File.dirname(__FILE__), "../../data/input_#{user}.json"))
				rescue => e
					print "error while opening file for user #{user} : #{e.message}"
					return nil
				end
				return JSON.load(file)
			end
		end
	end
end