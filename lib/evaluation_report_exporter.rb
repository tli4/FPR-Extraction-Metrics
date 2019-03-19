require 'csv'

class EvaluationReportExporter
  include ApplicationHelper

  HEADINGS = [
    "Term",
    "Subject",
    "Course",
    "Section",
    "Course Name",
    "Instructor",
    "Responses",
    "Enrollment",
    "Item 1 mean",
    "Item 2 mean",
    "Item 3 mean",
    "Item 4 mean",
    "Item 5 mean",
    "Item 6 mean",
    "Item 7 mean",
    "Item 8 mean",
    "Mean Student Eval Score",
    "Course Level Average"
  ]

  def initialize(evaluation_groups)
    @groups = evaluation_groups
  end

  def generate
    CSV.generate do |csv|
      csv << HEADINGS
      @groups.each do |group|
        group.each do |eval|
          csv << eval.csv_data
        end

        formula_data = ["Total"]
        5.times { formula_data.push("") }
        formula_data.push(compute_total_responses(group))
        formula_data.push(compute_total_enrollment(group))

        (1..8).each do |x|
          formula_data.push(compute_weighted_average_for_item(x, group).round(2))
        end

        formula_data.push(compute_mean_student_eval_score(group).round(2))
        formula_data.push(compute_course_level_average(group, @groups).round(2))
        csv << formula_data
        csv << formula_data.map { |_| "" }
      end
    end
  end
end
