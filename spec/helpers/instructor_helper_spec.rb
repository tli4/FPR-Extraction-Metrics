require 'rails_helper'

RSpec.describe InstructorHelper, type: :helper do
  describe "#course_name_for" do
    it "returns the subject and course number appended" do
      inst = FactoryGirl.create(:instructor)
      FactoryGirl.create(:evaluation, instructor: inst, subject: "CSCE", course: "121")
      expect(helper.course_name_for(inst.course_section_groups[0])).to eq("CSCE 121")
    end

    it "appends H to the course name if it is honors" do
      inst = FactoryGirl.create(:instructor)
      FactoryGirl.create(:evaluation, instructor: inst, subject: "CSCE", course: "121", section: 200)
      expect(helper.course_name_for(inst.course_section_groups[0])).to eq("CSCE 121H")
    end

    it "#is_honors" do
      expect(is_honors(221)).to eq("H")
      expect(is_honors(121)).to eq("")
    end 
  end
  
  describe "#term_format" do
    it "verifies terms were converted to SP/SU/FA format" do
      inst = FactoryGirl.create(:instructor)
      first = FactoryGirl.create(:evaluation, instructor: inst, subject: "CSCE", course: "121", term: '2015C')
      second = FactoryGirl.create(:evaluation, instructor: inst, subject: "CSCE", course: "121", term: '2015B')
      third = FactoryGirl.create(:evaluation, instructor: inst, subject: "CSCE", course: "121", term: '2010A')

      expect(helper.term_format(first.term)).to eq("FA15")
      expect(helper.term_format(second.term)).to eq("SU15")
      expect(helper.term_format(third.term)).to eq("SP10")
    end
  end
  
  describe "#put_last_name" do
    it "returns last name then first name" do
      inst = "Ben White"
      inst2 = "John Smith Doe"
      expect(helper.put_last_name(inst)).to eq("White, Ben ")
      expect(helper.put_last_name(inst2)).to eq("Doe, John Smith ")
    end
  end
  
  describe "#inst_list" do
    it "returns sorted instructor list" do
      inst = FactoryGirl.create(:instructor)
      FactoryGirl.create(:evaluation, instructor: inst, subject: "CSCE", course: "121")
      inst2 = FactoryGirl.create(:instructor)
      FactoryGirl.create(:evaluation, instructor: inst2, subject: "CSCE", course: "121")

      expect(helper.inst_list("status IS NULL")[0].name).to eq(inst.name)
      expect(helper.inst_list("status IS NULL")[1].name).to eq(inst2.name)
    end
  end
  
  describe "#get_complete_name" do
    it "returns full course name" do
      inst = FactoryGirl.create(:instructor)
      FactoryGirl.create(:evaluation, instructor: inst, subject: "CSCE", course: "121")
      expect(helper.get_complete_name(inst.course_section_groups[0])).to eq("CSCE 121")
    end
    
    it "appends H if honors" do
      inst = FactoryGirl.create(:instructor)
      FactoryGirl.create(:evaluation, instructor: inst, subject: "CSCE", course: "121", section: 200)
      expect(helper.get_complete_name(inst.course_section_groups[0])).to eq("CSCE 121H")
    end
  end
  
end
