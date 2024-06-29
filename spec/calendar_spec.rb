# frozen_string_literal: true
require "slot_machine/models/calendar"

RSpec.describe SlotMachine::Calendar do

  context "When it receives a file that exists" do
    let!(:calendar) {SlotMachine::Calendar.new("andy")}
    let(:start_time) {"2022-08-01T9:00:00+02:00"}
    let(:end_time) {"2022-08-01T18:00:00+02:00"}
    let(:start_time_busy_slots) {
      ["2022-08-01 09:00:00 +0200",
      "2022-08-02 09:00:00 +0200",
      "2022-08-02 15:00:00 +0200",
      "2022-08-03 09:00:00 +0200",
      "2022-08-04 10:00:00 +0200",
      "2022-08-04 16:00:00 +0200"]}
    
    let(:start_time_available_slots) {
      ["2022-08-01T14:00:00+02:00",
      "2022-08-01T15:00:00+02:00",
      "2022-08-01T16:00:00+02:00"]}
  
    it "parses it and fill a linked list" do
      expect(calendar.get_slot_array).to eq(start_time_busy_slots)
    end

    it "can return the available slots for the day" do
      expect(calendar.get_available_slots(start_time, end_time, 2)).to eq(start_time_available_slots)
    end
  end

  context "When it receives a NIGHTMARISH file" do
    let!(:calendar) {SlotMachine::Calendar.new("lucifer")}
    let(:start_time_busy_slots) {
      ["2022-08-01 09:00:00 +0200",
      "2022-08-01 12:00:00 +0200",
      "2022-08-01 16:00:00 +0200",
      "2022-08-02 12:00:00 +0200"]}

    it "parses it and fill a linked list" do
      expect(calendar.get_slot_array).to eq(start_time_busy_slots)
    end
  end
end
