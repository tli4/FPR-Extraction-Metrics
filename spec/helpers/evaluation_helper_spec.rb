require 'rails_helper'

RSpec.describe EvaluationHelper, type: :helper do
  describe "#compute_total_responses" do
    it "sums the reponses of group of courses" do
      eval = FactoryGirl.create(:evaluation, responses: 25)
      eval2 = FactoryGirl.create(:evaluation, responses: 25)
      expect(helper.compute_total_responses([eval, eval2])).to eq(50)
    end
  end

  describe "#compute_total_enrollment" do
    it "sums the enrollment of group of courses" do
      eval = FactoryGirl.create(:evaluation, enrollment: 50)
      eval2 = FactoryGirl.create(:evaluation, enrollment: 50)
      expect(helper.compute_total_enrollment([eval, eval2])).to eq(100)
    end
  end

  describe "#compute_weighted_average_for_item" do
    it "computes a weighted average for the specified evaluation question" do
      eval = FactoryGirl.create(:evaluation, enrollment: 50, item1_mean: 5.0)
      eval2 = FactoryGirl.create(:evaluation, enrollment: 50, item1_mean: 4.0)
      expect(helper.compute_weighted_average_for_item(1, [eval, eval2])).to be_within(0.0001).of(4.5)
    end
  end

  describe "#compute_mean_student_eval_score" do
    it "computes a weighted average for the specified evaluation question" do
      eval = FactoryGirl.create(:evaluation, enrollment: 50,
        item1_mean: 4.1, item2_mean: 4.1, item3_mean: 4.1, item4_mean: 4.1,
        item5_mean: 4.1, item6_mean: 4.1, item7_mean: 4.1, item8_mean: 4.1)
      eval2 = FactoryGirl.create(:evaluation, enrollment: 50,
        item1_mean: 3.9, item2_mean: 3.9, item3_mean: 3.9, item4_mean: 3.9,
        item5_mean: 3.9, item6_mean: 3.9, item7_mean: 3.9, item8_mean: 3.9)
      expect(helper.compute_mean_student_eval_score([eval, eval2])).to be_within(0.0001).of(4.0)
    end
    
    it "does not compute weighted student eval average if it is historical data" do
      eval = FactoryGirl.create(:evaluation, enrollment: 50,
        item1_mean: 4.1, item2_mean: 4.1, item3_mean: 4.1, item4_mean: 4.1,
        item5_mean: 4.1, item6_mean: 4.1, item7_mean: 4.1, item8_mean: 4.1, 
        mses: 4.0, dae: 3.9, ang: 3.7, dang: 3.6, history: 1)
      eval2 = FactoryGirl.create(:evaluation, enrollment: 50,
        item1_mean: 3.9, item2_mean: 3.9, item3_mean: 3.9, item4_mean: 3.9,
        item5_mean: 3.9, item6_mean: 3.9, item7_mean: 3.9, item8_mean: 3.9,
        mses: 4.0, dae: 3.9, ang: 3.7, dang: 3.6, history: 1)
      expect(helper.compute_mean_student_eval_score([eval,eval2])).to eq(4.0)
    end
  end

  describe "#compute_course_level_average" do
    let (:instructor1) { FactoryGirl.create(:instructor) }
    let (:instructor2) { FactoryGirl.create(:instructor) }
    let (:instructor3) { FactoryGirl.create(:instructor) }
    let (:instructor4) { FactoryGirl.create(:instructor) }
    let (:instructor5) { FactoryGirl.create(:instructor) }
    let (:instructor6) { FactoryGirl.create(:instructor) }
    let (:instructor7) { FactoryGirl.create(:instructor) }
    let (:one_hundred_level_courses) {
      [{:term=>"2015C", :subject=>"CSCE", :course=>110, :section=>501, :instructor=>instructor1, :enrollment=>24, :item1_mean=>4.46, :item2_mean=>4.46, :item3_mean=>4.46, :item4_mean=>4.08, :item5_mean=>4.46, :item6_mean=>4, :item7_mean=>3.85, :item8_mean=>4.38}, {:term=>"2015C", :subject=>"CSCE", :course=>110, :section=>502, :instructor=>instructor1, :enrollment=>29, :item1_mean=>4.07, :item2_mean=>4.27, :item3_mean=>4.27, :item4_mean=>4, :item5_mean=>4.27, :item6_mean=>4, :item7_mean=>3.4, :item8_mean=>3.8}, {:term=>"2015C", :subject=>"CSCE", :course=>110, :section=>503, :instructor=>instructor1, :enrollment=>23, :item1_mean=>4.71, :item2_mean=>4.29, :item3_mean=>4.14, :item4_mean=>4.29, :item5_mean=>4.43, :item6_mean=>4.14, :item7_mean=>4.14, :item8_mean=>4}, {:term=>"2015C", :subject=>"CSCE", :course=>111, :section=>501, :instructor=>instructor2, :enrollment=>33, :item1_mean=>3.57, :item2_mean=>3.86, :item3_mean=>3.57, :item4_mean=>4, :item5_mean=>3.43, :item6_mean=>3.57, :item7_mean=>4, :item8_mean=>3.33}, {:term=>"2015C", :subject=>"CSCE", :course=>111, :section=>502, :instructor=>instructor2, :enrollment=>29, :item1_mean=>4.2, :item2_mean=>4.4, :item3_mean=>3.8, :item4_mean=>4.4, :item5_mean=>3.8, :item6_mean=>3.6, :item7_mean=>4.2, :item8_mean=>4}, {:term=>"2015C", :subject=>"CSCE", :course=>111, :section=>503, :instructor=>instructor2, :enrollment=>27, :item1_mean=>4, :item2_mean=>4, :item3_mean=>3.67, :item4_mean=>4.22, :item5_mean=>3.89, :item6_mean=>3.56, :item7_mean=>4.33, :item8_mean=>3.89}, {:term=>"2015C", :subject=>"CSCE", :course=>111, :section=>504, :instructor=>instructor4, :enrollment=>35, :item1_mean=>4, :item2_mean=>4.29, :item3_mean=>3.93, :item4_mean=>4.43, :item5_mean=>4, :item6_mean=>4.15, :item7_mean=>4.36, :item8_mean=>4.36}, {:term=>"2015C", :subject=>"CSCE", :course=>111, :section=>505, :instructor=>instructor4, :enrollment=>34, :item1_mean=>3.25, :item2_mean=>3.88, :item3_mean=>3, :item4_mean=>3.88, :item5_mean=>4.5, :item6_mean=>4.38, :item7_mean=>4.13, :item8_mean=>3.88}, {:term=>"2015C", :subject=>"CSCE", :course=>111, :section=>506, :instructor=>instructor4, :enrollment=>19, :item1_mean=>3.14, :item2_mean=>3.43, :item3_mean=>3, :item4_mean=>3.71, :item5_mean=>3.71, :item6_mean=>3.71, :item7_mean=>3.71, :item8_mean=>3.71}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>200, :instructor=>instructor7, :enrollment=>24, :item1_mean=>4.14, :item2_mean=>4.1, :item3_mean=>3.9, :item4_mean=>4.48, :item5_mean=>4.38, :item6_mean=>4.29, :item7_mean=>4.24, :item8_mean=>4.33}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>201, :instructor=>instructor3, :enrollment=>3, :item1_mean=>2.5, :item2_mean=>2.5, :item3_mean=>3, :item4_mean=>4, :item5_mean=>3, :item6_mean=>4, :item7_mean=>3.5, :item8_mean=>2.5}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>207, :instructor=>instructor3, :enrollment=>3, :item1_mean=>3.5, :item2_mean=>3.5, :item3_mean=>4.5, :item4_mean=>3.5, :item5_mean=>4.5, :item6_mean=>3.5, :item7_mean=>5, :item8_mean=>4.5}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>211, :instructor=>instructor5, :enrollment=>2, :item1_mean=>3, :item2_mean=>3, :item3_mean=>3, :item4_mean=>3, :item5_mean=>3, :item6_mean=>3, :item7_mean=>3, :item8_mean=>3}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>217, :instructor=>instructor3, :enrollment=>7, :item1_mean=>3.33, :item2_mean=>3, :item3_mean=>3.67, :item4_mean=>4, :item5_mean=>3.33, :item6_mean=>3.33, :item7_mean=>3.33, :item8_mean=>3.67}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>220, :instructor=>instructor5, :enrollment=>1, :item1_mean=>3, :item2_mean=>4, :item3_mean=>3, :item4_mean=>3, :item5_mean=>3, :item6_mean=>3, :item7_mean=>3, :item8_mean=>3}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>222, :instructor=>instructor5, :enrollment=>1, :item1_mean=>3, :item2_mean=>3, :item3_mean=>2, :item4_mean=>4, :item5_mean=>4, :item6_mean=>4, :item7_mean=>3, :item8_mean=>3}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>501, :instructor=>instructor3, :enrollment=>21, :item1_mean=>3.75, :item2_mean=>3.5, :item3_mean=>3.75, :item4_mean=>3.75, :item5_mean=>3.5, :item6_mean=>3.5, :item7_mean=>3.5, :item8_mean=>3.5}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>502, :instructor=>instructor3, :enrollment=>19, :item1_mean=>3.75, :item2_mean=>3.63, :item3_mean=>3.38, :item4_mean=>4.13, :item5_mean=>3.75, :item6_mean=>3.88, :item7_mean=>4, :item8_mean=>3.86}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>503, :instructor=>instructor5, :enrollment=>18, :item1_mean=>3.58, :item2_mean=>3.58, :item3_mean=>3.5, :item4_mean=>4, :item5_mean=>3.83, :item6_mean=>3.75, :item7_mean=>3.58, :item8_mean=>3.58}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>504, :instructor=>instructor5, :enrollment=>20, :item1_mean=>3.38, :item2_mean=>3.63, :item3_mean=>3.53, :item4_mean=>3.94, :item5_mean=>3.44, :item6_mean=>3.69, :item7_mean=>3.81, :item8_mean=>3.69}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>505, :instructor=>instructor5, :enrollment=>23, :item1_mean=>3.21, :item2_mean=>3.74, :item3_mean=>3, :item4_mean=>3.68, :item5_mean=>3.74, :item6_mean=>3.53, :item7_mean=>3.11, :item8_mean=>3.42}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>506, :instructor=>instructor5, :enrollment=>24, :item1_mean=>3.29, :item2_mean=>3.5, :item3_mean=>3.14, :item4_mean=>3.86, :item5_mean=>3.71, :item6_mean=>3.93, :item7_mean=>3.21, :item8_mean=>3.29}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>507, :instructor=>instructor3, :enrollment=>26, :item1_mean=>3.64, :item2_mean=>3.73, :item3_mean=>4.27, :item4_mean=>3.91, :item5_mean=>3.82, :item6_mean=>3.82, :item7_mean=>3.82, :item8_mean=>3.64}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>508, :instructor=>instructor3, :enrollment=>22, :item1_mean=>3.6, :item2_mean=>3.8, :item3_mean=>3.2, :item4_mean=>3.6, :item5_mean=>3.6, :item6_mean=>3.6, :item7_mean=>4, :item8_mean=>3.6}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>509, :instructor=>instructor3, :enrollment=>23, :item1_mean=>4.33, :item2_mean=>3.67, :item3_mean=>4.33, :item4_mean=>4.33, :item5_mean=>4.33, :item6_mean=>4, :item7_mean=>4, :item8_mean=>4.33}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>510, :instructor=>instructor5, :enrollment=>27, :item1_mean=>3.61, :item2_mean=>3.5, :item3_mean=>3.56, :item4_mean=>3.89, :item5_mean=>3.56, :item6_mean=>3.56, :item7_mean=>3.33, :item8_mean=>3.39}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>511, :instructor=>instructor5, :enrollment=>22, :item1_mean=>3.8, :item2_mean=>3.79, :item3_mean=>3.73, :item4_mean=>4.07, :item5_mean=>3.73, :item6_mean=>4, :item7_mean=>3.87, :item8_mean=>3.87}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>512, :instructor=>instructor5, :enrollment=>20, :item1_mean=>3.3, :item2_mean=>3.1, :item3_mean=>3.3, :item4_mean=>3.7, :item5_mean=>3.4, :item6_mean=>3.5, :item7_mean=>3.1, :item8_mean=>3.2}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>513, :instructor=>instructor5, :enrollment=>15, :item1_mean=>3.46, :item2_mean=>3.42, :item3_mean=>3.15, :item4_mean=>3.92, :item5_mean=>3.62, :item6_mean=>4, :item7_mean=>3.38, :item8_mean=>3.23}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>514, :instructor=>instructor3, :enrollment=>19, :item1_mean=>4, :item2_mean=>4.2, :item3_mean=>4.5, :item4_mean=>4.17, :item5_mean=>4.17, :item6_mean=>4, :item7_mean=>4.33, :item8_mean=>3.83}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>515, :instructor=>instructor3, :enrollment=>32, :item1_mean=>4, :item2_mean=>3.67, :item3_mean=>3.67, :item4_mean=>4, :item5_mean=>4, :item6_mean=>3.78, :item7_mean=>3.44, :item8_mean=>3.67}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>516, :instructor=>instructor3, :enrollment=>20, :item1_mean=>4, :item2_mean=>3.86, :item3_mean=>3.43, :item4_mean=>3.71, :item5_mean=>4, :item6_mean=>3.43, :item7_mean=>4, :item8_mean=>3.71}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>517, :instructor=>instructor3, :enrollment=>30, :item1_mean=>3.75, :item2_mean=>3.5, :item3_mean=>3.5, :item4_mean=>4, :item5_mean=>3.5, :item6_mean=>3.5, :item7_mean=>3.5, :item8_mean=>3.75}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>518, :instructor=>instructor3, :enrollment=>32, :item1_mean=>4.13, :item2_mean=>3.88, :item3_mean=>3.88, :item4_mean=>4, :item5_mean=>4, :item6_mean=>4.13, :item7_mean=>4, :item8_mean=>3.88}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>519, :instructor=>instructor3, :enrollment=>28, :item1_mean=>3.63, :item2_mean=>3.63, :item3_mean=>2.88, :item4_mean=>3.5, :item5_mean=>3.13, :item6_mean=>3.13, :item7_mean=>3.75, :item8_mean=>3.75}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>520, :instructor=>instructor5, :enrollment=>18, :item1_mean=>3.33, :item2_mean=>3.33, :item3_mean=>3, :item4_mean=>4.33, :item5_mean=>3.5, :item6_mean=>3.67, :item7_mean=>3.67, :item8_mean=>3.17}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>521, :instructor=>instructor5, :enrollment=>19, :item1_mean=>3, :item2_mean=>3.5, :item3_mean=>2.78, :item4_mean=>3.78, :item5_mean=>3.38, :item6_mean=>3.78, :item7_mean=>3.44, :item8_mean=>3.56}, {:term=>"2015C", :subject=>"CSCE", :course=>121, :section=>522, :instructor=>instructor5, :enrollment=>15, :item1_mean=>3, :item2_mean=>2.63, :item3_mean=>2.88, :item4_mean=>3.38, :item5_mean=>3.13, :item6_mean=>3.5, :item7_mean=>3.43, :item8_mean=>3.25}, {:term=>"2015C", :subject=>"CSCE", :course=>181, :section=>500, :instructor=>instructor6, :enrollment=>156, :item1_mean=>4.49, :item2_mean=>4.16, :item3_mean=>4.56, :item4_mean=>4.48, :item5_mean=>4.33, :item6_mean=>4.18, :item7_mean=>4.52, :item8_mean=>4.44}]
    }

    it "computes the course level average from each of the grouped course averages" do
      one_hundred_level_courses.each { |attrs| FactoryGirl.create(:evaluation, attrs) }
      expect(Evaluation.count).to eq(41)

      evaluation_groups = Evaluation.default_sorted_groups
      expect(helper.compute_course_level_average(evaluation_groups.first, evaluation_groups)).to be_within(0.005).of(3.83)
    end
    
    it "does not compute course level average if it is historical data" do
      eval = FactoryGirl.create(:evaluation, enrollment: 50,
        item1_mean: 4.1, item2_mean: 4.1, item3_mean: 4.1, item4_mean: 4.1,
        item5_mean: 4.1, item6_mean: 4.1, item7_mean: 4.1, item8_mean: 4.1, 
        mses: 4.0, dae: 3.9, ang: 3.7, dang: 3.6, history: 1)
      eval2 = FactoryGirl.create(:evaluation, enrollment: 50,
        item1_mean: 3.9, item2_mean: 3.9, item3_mean: 3.9, item4_mean: 3.9,
        item5_mean: 3.9, item6_mean: 3.9, item7_mean: 3.9, item8_mean: 3.9,
        mses: 4.0, dae: 3.9, ang: 3.7, dang: 3.6, history: 1)
      evaluation_groups = Evaluation.default_sorted_groups
      expect(helper.compute_course_level_average([eval,eval2], evaluation_groups)).to eq(3.9)
    end
  end

  describe "#compute_mean_gpr" do
    it "computes a weighted average for the specified evaluation question" do
      eval = FactoryGirl.create(:evaluation, gpr: 3.5)
      eval2 = FactoryGirl.create(:evaluation, gpr: 4.0)
      expect(helper.compute_mean_gpr([eval, eval2])).to be_within(0.0001).of(3.75)
    end
    
    it "does not compute gpr if it is historical data" do
      eval = FactoryGirl.create(:evaluation, enrollment: 50,
        item1_mean: 4.1, item2_mean: 4.1, item3_mean: 4.1, item4_mean: 4.1,
        item5_mean: 4.1, item6_mean: 4.1, item7_mean: 4.1, item8_mean: 4.1, 
        mses: 4.0, dae: 3.9, ang: 3.7, dang: 3.6, history: 1)
      eval2 = FactoryGirl.create(:evaluation, enrollment: 50,
        item1_mean: 3.9, item2_mean: 3.9, item3_mean: 3.9, item4_mean: 3.9,
        item5_mean: 3.9, item6_mean: 3.9, item7_mean: 3.9, item8_mean: 3.9,
        mses: 4.0, dae: 3.9, ang: 3.7, dang: 3.6, history: 1)
      expect(helper.compute_mean_gpr([eval,eval2])).to eq(3.7)
    end
  end
  
  describe "#is_number?" do
    it "determines if it is a integer/float" do
      num = "50"
      expect(helper.is_number?num).to eq(true)
    end
  end
end
