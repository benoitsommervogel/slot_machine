# frozen_string_literal: true
require "slot_machine/models/user"

RSpec.describe SlotMachine::User do

  context "When the user has a clean schedule" do

    let!(:user) {SlotMachine::User.new("andy")}
    
    context "and want slots when some are available" do
      let(:start_time) {"2022-08-01T9:00:00+02:00"}
      let(:end_time) {"2022-08-01T18:00:00+02:00"}
      let(:start_time_available_slots) {
        ["2022-08-01T14:00:00+02:00",
        "2022-08-01T15:00:00+02:00",
        "2022-08-01T16:00:00+02:00",
        "2022-08-01T17:00:00+02:00"]}

      it "can return the available slots for the day" do
        expect(user.get_available_slots(start_time, end_time, 1)).to eq(start_time_available_slots)
      end
    end

    context "and want slots when none are available" do
      let(:start_time) {"2022-08-03T9:00:00+02:00"}
      let(:end_time) {"2022-08-03T18:00:00+02:00"}
      it "doesn't return any slot" do
        expect(user.get_available_slots(start_time, end_time, 1)).to eq([])
      end
    end
  end

  context "When the user has a big schedule" do

    let!(:user) {SlotMachine::User.new("sandra")}

    context "and we want slots for a day" do
      let(:start_time) {"2022-08-02T9:00:00+02:00"}
      let(:end_time) {"2022-08-02T18:00:00+02:00"}
      
      let(:start_time_available_slots) {
        ["2022-08-02T10:00:00+02:00",
        "2022-08-02T11:00:00+02:00",
        "2022-08-02T17:00:00+02:00"]}
      it "can return the available slots for the day" do
        expect(user.get_available_slots(start_time, end_time, 1)).to eq(start_time_available_slots)
      end
    end

    context "and we want slots for two days" do
      let(:start_time) {"2022-08-02T9:00:00+02:00"}
      let(:end_time) {"2022-08-03T18:00:00+02:00"}
      
      let(:start_time_available_slots) {
        ["2022-08-02T10:00:00+02:00",
        "2022-08-02T11:00:00+02:00",
        "2022-08-02T17:00:00+02:00",
        "2022-08-03T09:00:00+02:00",
        "2022-08-03T10:00:00+02:00",
        "2022-08-03T11:00:00+02:00",
        "2022-08-03T12:00:00+02:00",
        "2022-08-03T15:00:00+02:00"]}
      it "can return the available slots for the two days" do
        expect(user.get_available_slots(start_time, end_time, 1)).to eq(start_time_available_slots)
      end
    end
  end

  context "When the user has a messy schedule (bad API)" do

    let!(:user) {SlotMachine::User.new("lucifer")}
    let(:start_time) {"2022-08-01T9:00:00+02:00"}
    let(:end_time) {"2022-08-01T18:00:00+02:00"}
    
    let(:start_time_available_slots) {
      ["2022-08-01T15:00:00+02:00"]}

    it "can return the available slots for the day DESPITE ALL ODDS" do
      expect(user.get_available_slots(start_time, end_time, 1)).to eq(start_time_available_slots)
    end
  end
end
