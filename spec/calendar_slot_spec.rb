# frozen_string_literal: true
require "slot_machine/models/calendar_slot"

RSpec.describe SlotMachine::CalendarSlot do
  let!(:first_slot) {SlotMachine::CalendarSlot.new("2022-08-02T09:00:00+02:00", "2022-08-02T015:00:00+02:00")}
  let!(:second_slot) {SlotMachine::CalendarSlot.new("2022-08-02T17:00:00+02:00", "2022-08-02T18:00:00+02:00")}

  before do
    first_slot.next_slot = second_slot
  end

  context "when two slots exist on the same day" do
    let!(:result) {["2022-08-02T15:00:00+02:00", "2022-08-02T16:00:00+02:00"]}

    it "returns the available slots between them" do
      expect(first_slot.get_available_slots_between(1)).to eq(result)
    end
  end

  context "when two slots exist on the same day and we want a big one" do
    let!(:result) {["2022-08-02T15:00:00+02:00"]}

    it "returns the available big slots between them" do
      expect(first_slot.get_available_slots_between(2)).to eq(result)
    end
  end

  context "when two slots exist on different days" do
    let!(:second_slot) {SlotMachine::CalendarSlot.new("2022-09-02T10:00:00+02:00", "2022-09-02T015:00:00+02:00")}
    let!(:result) {["2022-08-02T15:00:00+02:00", "2022-08-02T16:00:00+02:00", "2022-08-02T17:00:00+02:00", "2022-09-02T09:00:00+02:00"]}

    it "returns the number of available slots between them, except outside work hours" do
      expect(first_slot.get_available_slots_between(1)).to eq(result)
    end
  end
end
  