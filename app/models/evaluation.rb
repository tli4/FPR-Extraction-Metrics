class Evaluation < ActiveRecord::Base

  belongs_to :instructor
  #belongs_to :course_name
  validates_associated :instructor
  #validates_associated :course_name

  def self.all_Items
     self.all.select(:Item).distinct.order(:Item).pluck(:Item)
  end

  # needed for rolify
  resourcify

  validates :term, presence: true, format: { with: /\A[12][0-9]{3}[A-Z]\z/,
    message: "must be in the format: xxxxY where xxxx is year and Y is semester letter. Example: 2015C" }
  validates :subject, presence: true, format: { with: /\A[A-Z]{4}\z/,
    message: "must be four capital letters." }
  validates :course, presence: true, numericality: { only_integer: true }
  validates :section, presence: true, numericality: { only_integer: true }
  validates :responses, numericality: { only_integer: true, allow_blank: true }
  validates :enrollment, numericality: { only_integer: true, allow_blank: true }
  validates :item1_mean, numericality: { allow_blank: true}, inclusion: { in: 0..5, message: "must be between 0 and 5." }
  validates :item2_mean, numericality: { allow_blank: true}, inclusion: { in: 0..5, message: "must be between 0 and 5." }
  validates :item3_mean, numericality: { allow_blank: true}, inclusion: { in: 0..5, message: "must be between 0 and 5." }
  validates :item4_mean, numericality: { allow_blank: true}, inclusion: { in: 0..5, message: "must be between 0 and 5." }
  validates :item5_mean, numericality: { allow_blank: true}, inclusion: { in: 0..5, message: "must be between 0 and 5." }
  validates :item6_mean, numericality: { allow_blank: true}, inclusion: { in: 0..5, message: "must be between 0 and 5." }
  validates :item7_mean, numericality: { allow_blank: true}, inclusion: { in: 0..5, message: "must be between 0 and 5." }
  validates :item8_mean, numericality: { allow_blank: true}, inclusion: { in: 0..5, message: "must be between 0 and 5." }

  scope :no_missing_data, -> {where.not("instructor_id is NULL OR enrollment is NULL OR item1_mean is NULL OR item2_mean is NULL OR item3_mean is NULL OR item4_mean is NULL OR item5_mean is NULL OR item6_mean is NULL OR item7_mean is NULL OR item8_mean is NULL")}
  scope :missing_data, ->{where("instructor_id is NULL OR enrollment is NULL OR item1_mean is NULL OR item2_mean is NULL OR item3_mean is NULL OR item4_mean is NULL OR item5_mean is NULL OR item6_mean is NULL OR item7_mean is NULL OR item8_mean is NULL OR gpr is NULL")}

  KEY_ATTRIBUTES = [:term, :subject, :course, :section].freeze

  def self.key_attributes
    KEY_ATTRIBUTES
  end

  def self.create_if_needed_and_update(key_attrs, other_attrs)
    if other_attrs[:instructor].is_a?(String) && !other_attrs[:instructor].empty?
      new_instructor = Instructor.where(name: Instructor.normalize_name(other_attrs[:instructor])).first_or_create
    end
    other_attrs.delete(:instructor)

    evaluation = where(key_attrs).first_or_initialize
    is_new_record = evaluation.new_record?
    evaluation.save

    if new_instructor && (evaluation.instructor.nil? || evaluation.instructor.name.length < new_instructor.name.length || other_attrs[:instructor_id].to_s == "0")
      other_attrs[:instructor_id] = new_instructor.id
    end

    subj_course = key_attrs[:subject].to_s + " " + key_attrs[:course].to_s;
    new_course = CourseName.where(subject_course: subj_course).first_or_initialize
    new_course.save

    evaluation.update(other_attrs)

    [ evaluation, is_new_record ]
  end

  def self.default_sorted_groups
    n = 0
    all.group_by do |eval| # start by grouping them by the groupings above
      eval.term.to_s + eval.subject.to_s + eval.course.to_s + eval.instructor.try(:id).to_s + eval.section.to_s[0]
    end
    .sort { |group1, group2| group1.first <=> group2.first } # sort by their "group by" keys
    .map(&:last) # only take the groups and not the keys
    .map { |group| group.sort_by(&:section) } # sort each group by section
    .map { |group| group.sort_by { |ev| n+=1; [ev[:course], n] } } # stable sort each group by course
  end

  def self.instructor_sorted_groups
    n = 0
    all.group_by do |eval| # start by grouping them by the groupings above
      eval.instructor.try(:id).to_s
    end
    .sort { |group1, group2| group1.first <=> group2.first } # sort by their "group by" keys
    .map(&:last) # only take the groups and not the keys
    .map { |group| group.sort_by { |ev| n+=1; [ev[:section], n] } } # stable sort each group by section
    .map { |group| group.sort_by { |ev| n+=1; [ev[:course], n] }.reverse! } # stable sort each group by course
    .map { |group| group.sort_by { |ev| n+=1; [ev[:term], n] }.reverse! } # stable sort each group by term
  end

  def self.course_sorted_groups
    n = 0
    all.group_by do |eval| # start by grouping them by the groupings above
      eval.course.to_s
    end
    .sort { |group1, group2| group1.first <=> group2.first } # sort by their "group by" keys
    .map(&:last) # only take the groups and not the keys
    .map { |group| group.sort_by { |ev| n+=1; [ev[:section], n] } } # stable sort each group by section
    .map { |group| group.sort_by { |ev| n+=1; [ev[:course], n] }.reverse! } # stable sort each group by course
    .map { |group| group.sort_by { |ev| n+=1; [ev[:term], n] }.reverse! } # stable sort each group by term
  end

  def self.level_sorted_groups
    n = 0
    all.group_by do |eval| # start by grouping them by the groupings above
      eval.course.to_s.first
    end
    .sort { |group1, group2| group1.first <=> group2.first } # sort by their "group by" keys
    .map(&:last) # only take the groups and not the keys
    .map { |group| group.sort_by { |ev| n+=1; [ev[:section], n] } } # stable sort each group by section
    .map { |group| group.sort_by { |ev| n+=1; [ev[:course], n] }.reverse! } # stable sort each group by course
    .map { |group| group.sort_by { |ev| n+=1; [ev[:term], n] }.reverse! } # stable sort each group by term
  end

  def self.semester_sorted_groups
    n = 0
    all.group_by do |eval| # start by grouping them by the groupings above
      eval.term.to_s
    end
    .sort { |group1, group2| group2.first <=> group1.first } # sort by their "group by" keys
    .map(&:last) # only take the groups and not the keys
    .map { |group| group.sort_by(&:section) } # sort each group by section
    .map { |group| group.sort_by { |ev| n+=1; [ev[:course], n] } } # stable sort each group by course
  end

  def key
    attributes.select { |k, _| Evaluation.key_attributes.include? k.to_sym }
  end

  def is_honors_section?
    section.to_s.starts_with?("2")
  end

  def subject_course
    "#{subject} #{course}"
  end

  def has_course_name?
    !course_name.nil?
  end

  def course_name
    CourseName.where(subject_course: subject_course).first.try(:name)
  end

  def csv_data
    [
      term,
      subject,
      course,
      section,
      course_name,
      instructor.name,
      responses,
      enrollment,
      item1_mean,
      item2_mean,
      item3_mean,
      item4_mean,
      item5_mean,
      item6_mean,
      item7_mean,
      item8_mean
    ].map(&:to_s)
  end
end
