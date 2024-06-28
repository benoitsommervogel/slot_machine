# frozen_string_literal: true
require "slot_machine/models/calendar"

RSpec.describe SlotMachine::Calendar do
  let!(:calendar) {SlotMachine::Calendar.new("andy")}
  let(:start_time) {"2022-08-02T9:00:00+02:00"}
  let(:end_time) {"2022-08-02T18:00:00+02:00"}

  context "When it receives a file that exists" do
    it "parses it and fill a linked list" do
      expect(calendar.get_calendar_size).to eq(6)
    end

    it "can return the available slots for the day" do
      expect(calendar.get_available_slots(start_time, end_time, 1).size).to eq(6)
    end
  end
end
