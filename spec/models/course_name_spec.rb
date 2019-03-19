require 'rails_helper'

RSpec.describe CourseName, type: :model do
  let(:instructor) { Instructor.create(name: 'Brent Walther') }
  let (:key_attrs) { {:term=>"2015C", :subject=>"CSCE", :course=>110, :section=>501} }
  let (:other_attrs) { {:instructor=> instructor , :enrollment=>24, :item1_mean=>4.46,
    :item2_mean=>4.46, :item3_mean=>4.46, :item4_mean=>4.08, :item5_mean=>4.46,
    :item6_mean=>4, :item7_mean=>3.85, :item8_mean=>4.38} }
  it "Evaluation should add the course to the table" do
    Evaluation.create_if_needed_and_update(key_attrs, other_attrs)
    course = CourseName.where(subject_course: 'CSCE 110').first_or_initialize
    expect(course.new_record?).to be false
  end
end
