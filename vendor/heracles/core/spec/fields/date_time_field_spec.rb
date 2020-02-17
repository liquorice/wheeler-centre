require "spec_helper"

describe Heracles::Fielded::DateTimeField do
  subject(:field) do
    described_class.new.tap do |field|
      config_attributes.each do |attr, value|
        field.send :"#{attr}=", value
      end

      field.assign(attributes)
    end
  end

  let(:attributes) { Hash.new }
  let(:config_attributes) { Hash.new }

  describe "#assign" do
    let(:new_attributes) { Hash.new }

    before do
      field.assign(new_attributes)
    end

    context "time provided as components" do
      let(:time) { Time.local(2014,1,1,10,55) }
      let(:new_attributes) { {value_date: "1988-12-20", value_time: "9:55", time_zone: "Canberra", value: time} }

      it "sets the date component" do
        expect(field.value_date).to eq "1988-12-20"
      end

      it "sets the time component" do
        expect(field.value_time).to eq "9:55"
      end

      it "sets the timezone" do
        expect(field.time_zone).to eq "Canberra"
      end

      it "prioritises the component values over a fully populated time value" do
        expect(field.value).to be_present
        expect(field.value).to_not eq time
      end
    end

    context "fully populated time object passed" do
      let(:time) { Time.find_zone!("Melbourne").local(2014,1,1,10,55) }
      let(:new_attributes) { {value: time} }

      it "sets a fully populated time, if it is present" do
        expect(field.value).to eq time
      end

      it "sets the time zone from the fully populated time object" do
        expect(field.time_zone).to eq "Melbourne"
      end
    end

    it "preserves existing values if nothing new is assigned" do
      time = Time.find_zone!("Melbourne").local(2014,1,1,10,55)
      field.value = time

      field.assign({})

      expect(field.value).to eq time
    end

    it "unsets values if empty strings are passed" do
      field.value = Time.find_zone!("Melbourne").local(2014,1,1,10,55)

      field.assign({value: nil})

      expect(field.value).to be_nil
      expect(field.time_zone).to be_nil
    end
  end

  describe "#value" do
    it "combines separate date, time and time zone attributes into a single time value" do
      field.value_date = "20 December 1988"
      field.value_time = "23:55"
      field.time_zone = "Canberra"

      # Account for the +11 AEDT time zone here
      expect(field.value).to eq Time.utc(1988,12,20,12,55).in_time_zone("Canberra")
    end

    context "date-only field" do
      let(:config_attributes) { {field_is_date_only: true} }

      it "sets the time value to midnight (UTC) on the date provided" do
        field.value_date = "20 December 1988"

        expect(field.value).to eq Time.utc(1988,12,20)
      end
    end
  end

  describe "#value_date" do
    it "returns the date in YYYY-MM-DD format" do
      field.value_date = "20 December 1988"
      expect(field.value_date).to eq "1988-12-20"
    end
  end

  describe "#value_time" do
    it "returns the time in HH:MM format" do
      field.value_time = "09:23"
      expect(field.value_time).to eq "09:23"
    end
  end

  describe "#time_zone" do
    context "date and time field" do
      let(:attributes) { {value_date: "20 December 1988", value_time: "9:55", time_zone: "Canberra"} }

      it "is the provided value" do
        expect(field.time_zone).to eq "Canberra"
      end
    end

    context "date-only field" do
      let(:config_attributes) { {field_is_date_only: true} }
      let(:attributes) { {value_date: "20 December 1988"} }

      it "is UTC" do
        expect(field.time_zone).to eq "UTC"
      end
    end
  end

  describe "validations" do
    context "date and time field" do
      let(:attributes) { {value_date: "20 December 1988", value_time: "9:55", time_zone: "Canberra"} }

      it "is valid with date, time and time zone attributes" do
        expect(field).to be_valid
      end

      it "is invalid without a date" do
        field.value_date = ""
        expect(field).to_not be_valid
      end

      it "is invalid without a time" do
        field.value_time = ""
        expect(field).to_not be_valid
      end

      it "is invalid without a time zone" do
        field.time_zone = ""
        expect(field).to_not be_valid
      end
    end

    context "date-only field" do
      let(:config_attributes) { {field_is_date_only: true} }

      let(:attributes) { {value_date: "20 December 1988"} }

      it "is valid with a date only" do
        expect(field).to be_valid
      end
    end
  end
end
