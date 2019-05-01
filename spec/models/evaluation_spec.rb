require 'rails_helper'

RSpec.describe Evaluation, type: :model do

  let(:instructor) { Instructor.create(name: 'Brent Walther') }

  it "should belong to an instructor" do
    eval = Evaluation.create(term: '2015C', subject: 'CSCE', course: '110',
      section: '501', instructor: instructor, enrollment: 10)

    expect(eval.instructor).to eq(instructor)
  end

  describe "#create_if_needed_and_update" do
    let (:key_attrs) { {:term=>"2015C", :subject=>"CSCE", :course=>110, :section=>501} }
    let (:other_attrs) { {:instructor=> instructor , :enrollment=>24, :item1_mean=>4.46,
      :item2_mean=>4.46, :item3_mean=>4.46, :item4_mean=>4.08, :item5_mean=>4.46,
      :item6_mean=>4, :item7_mean=>3.85, :item8_mean=>4.38} }

    it "returns true if the record didn't exist" do
      _, is_new = Evaluation.create_if_needed_and_update(key_attrs, other_attrs)
      expect(is_new).to be true
    end

    it "returns false if the record already existed" do
      Evaluation.create(key_attrs.merge(other_attrs))
      _, is_new = Evaluation.create_if_needed_and_update(key_attrs, other_attrs)
      expect(is_new).to be false
    end

    it "creates a new record if one does not already exist" do
      expect(Evaluation.all.count).to eq(0)
      Evaluation.create_if_needed_and_update(key_attrs, other_attrs)
      expect(Evaluation.all.count).to eq(1)
    end

    it "doesn't create a new record if one already exists" do
      Evaluation.create(key_attrs.merge(other_attrs))
      expect(Evaluation.all.count).to eq(1)

      Evaluation.create_if_needed_and_update(key_attrs, other_attrs)
      expect(Evaluation.all.count).to eq(1)
    end

    it "converts a string instructor name to an actual instructor" do
      string_name = "Kevin Sumlin"
      other_attrs[:instructor] = string_name
      expect { Evaluation.create_if_needed_and_update(key_attrs, other_attrs) }.to_not raise_exception
      expect(Evaluation.all.count).to eq(1)
      expect(Instructor.where(name: string_name).count).to eq(1)
    end

    it "replaces the instructor if a better name is available" do
      other_attrs[:instructor] = Instructor.create(name: 'WALTHER B')
      eval = Evaluation.create(key_attrs.merge(other_attrs))

      other_attrs[:instructor] = 'Brent Walther'
      Evaluation.create_if_needed_and_update(key_attrs, other_attrs)
      eval.reload
      expect(eval.instructor.name).to eq("Brent Walther")
    end

    it "doesn't clobber the instructor name if it is worse" do
      eval = Evaluation.create(key_attrs.merge(other_attrs))

      other_attrs[:instructor] = 'WALTHER B'
      Evaluation.create_if_needed_and_update(key_attrs, other_attrs)
      eval.reload
      expect(eval.instructor.name).to eq("Brent Walther")
    end
  end

  describe "#default_sorted_groups" do
    let (:other_required_attrs) { {:enrollment=>24, :item1_mean=>4.46,
      :item2_mean=>4.46, :item3_mean=>4.46, :item4_mean=>4.08, :item5_mean=>4.46,
      :item6_mean=>4, :item7_mean=>3.85, :item8_mean=>4.38} }
    it "groups terms together" do
      g11 = Evaluation.create({ term: "2014C", subject: "CSCE", course: "110", section: "501", instructor: instructor }.merge(other_required_attrs))
      g12 = Evaluation.create({ term: "2014C", subject: "CSCE", course: "110", section: "502", instructor: instructor }.merge(other_required_attrs))
      g21 = Evaluation.create({ term: "2015C", subject: "CSCE", course: "110", section: "501", instructor: instructor }.merge(other_required_attrs))
      g22 = Evaluation.create({ term: "2015C", subject: "CSCE", course: "110", section: "502", instructor: instructor }.merge(other_required_attrs))

      expect(Evaluation.default_sorted_groups).to eq([[g11, g12], [g21, g22]])
    end

    it "groups subject together" do
      g11 = Evaluation.create({ term: "2015C", subject: "CSCE", course: "110", section: "501", instructor: instructor }.merge(other_required_attrs))
      g12 = Evaluation.create({ term: "2015C", subject: "CSCE", course: "110", section: "502", instructor: instructor }.merge(other_required_attrs))
      g21 = Evaluation.create({ term: "2015C", subject: "ENGR", course: "110", section: "501", instructor: instructor }.merge(other_required_attrs))
      g22 = Evaluation.create({ term: "2015C", subject: "ENGR", course: "110", section: "502", instructor: instructor }.merge(other_required_attrs))

      expect(Evaluation.default_sorted_groups).to eq([[g11, g12], [g21, g22]])
    end

    it "groups courses together" do
      g11 = Evaluation.create({ term: "2015C", subject: "CSCE", course: "110", section: "501", instructor: instructor }.merge(other_required_attrs))
      g12 = Evaluation.create({ term: "2015C", subject: "CSCE", course: "110", section: "502", instructor: instructor }.merge(other_required_attrs))
      g21 = Evaluation.create({ term: "2015C", subject: "CSCE", course: "111", section: "501", instructor: instructor }.merge(other_required_attrs))
      g22 = Evaluation.create({ term: "2015C", subject: "CSCE", course: "111", section: "502", instructor: instructor }.merge(other_required_attrs))

      expect(Evaluation.default_sorted_groups).to eq([[g11, g12], [g21, g22]])
    end

    it "groups 200s and 500s sections together" do
      g11 = Evaluation.create({ term: "2015C", subject: "CSCE", course: "110", section: "201", instructor: instructor }.merge(other_required_attrs))
      g12 = Evaluation.create({ term: "2015C", subject: "CSCE", course: "110", section: "202", instructor: instructor }.merge(other_required_attrs))
      g21 = Evaluation.create({ term: "2015C", subject: "CSCE", course: "110", section: "501", instructor: instructor }.merge(other_required_attrs))
      g22 = Evaluation.create({ term: "2015C", subject: "CSCE", course: "110", section: "502", instructor: instructor }.merge(other_required_attrs))

      expect(Evaluation.default_sorted_groups).to eq([[g11, g12], [g21, g22]])
    end

    it "groups instructors together" do
      instructor2 = Instructor.create(name: "Kevin Sumlin")
      g11 = Evaluation.create({ term: "2015C", subject: "CSCE", course: "110", section: "501", instructor: instructor2 }.merge(other_required_attrs))
      g12 = Evaluation.create({ term: "2015C", subject: "CSCE", course: "110", section: "502", instructor: instructor2 }.merge(other_required_attrs))
      g21 = Evaluation.create({ term: "2015C", subject: "CSCE", course: "110", section: "503", instructor: instructor }.merge(other_required_attrs))
      g22 = Evaluation.create({ term: "2015C", subject: "CSCE", course: "110", section: "504", instructor: instructor }.merge(other_required_attrs))

      expect(Evaluation.default_sorted_groups).to eq([[g11, g12], [g21, g22]])
    end
  end

  describe "#is_honors_section?" do
    it "returns true for sections in the 200s which are honors sections" do
      expect(FactoryGirl.build(:evaluation, section: 200).is_honors_section?).to eq(true)
    end
  end

  describe "#has_course_name?" do
    it "returns true if the course has a course name" do
      name = "MyName"
      eval = FactoryGirl.create(:evaluation, subject: "CSCE", course: 121)
      FactoryGirl.create(:course_name, subject_course: "CSCE 121", name: name)
      expect(eval.has_course_name?).to eq(true)
    end

    it "returns false if the course does not have a course name" do
      eval = FactoryGirl.create(:evaluation, subject: "CSCE", course: 121)
      expect(eval.has_course_name?).to eq(false)
    end
  end

  describe "#course_name" do
    it "returns the course name" do
      name = "MyName"
      eval = FactoryGirl.create(:evaluation, subject: "CSCE", course: 121)
      FactoryGirl.create(:course_name, subject_course: "CSCE 121", name: name)
      expect(eval.course_name).to eq(name)
    end
  end
end
