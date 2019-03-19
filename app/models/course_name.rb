class CourseName < ActiveRecord::Base
  validates :subject_course, presence: true, uniqueness: true, format: { with: /\A[A-Z]{4} \d{3}\z/,
    message: "must be in the form ABCD 123. (e.g. CSCE 121)" }
  validates :name, allow_blank: true , format: { with: /\w/,
    message: "problem with course name format" }

  def self.create_if_needed_and_update(attrs)
    course_name = where(subject_course: attrs[:subject_course]).first_or_initialize
    is_new_record = course_name.new_record?
    course_name.save
    course_name.update(attrs)
    [ course_name, is_new_record ]
  end


end
