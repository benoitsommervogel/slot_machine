require "date"
require "json"

module SlotMachine
	module Calendar
		class GetCalendar

			def initialize
				#nothing here unfortunately in the context of the exercise
			end

			def fetch(user)
				begin
					file = File.open("/data/input_#{user}.json")
				rescue => e
					print "error while opening file for user #{user} : #{e.message}"
					return nil
				end
				return JSON.load(file)
			end
		end
	end
end