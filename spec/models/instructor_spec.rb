require 'rails_helper'

RSpec.describe Instructor, type: :model do
  describe ".select_menu_options" do
    it "includes all instructors with evaluations and a new instructor option" do
      inst = Instructor.create(name: 'Brent Walther')
      FactoryGirl.create(:evaluation, instructor: inst)
      expect(Instructor.select_menu_options.size).to eq(2)
    end

    it "does not include instructors that don't have an evaluation" do
      Instructor.create(name: 'Brent Walther')
      expect(Instructor.select_menu_options.size).to eq(1)
    end
  end
end
