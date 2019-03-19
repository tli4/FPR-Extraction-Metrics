class Instructor < ActiveRecord::Base
  has_many :evaluations

  # needed for rolify
  resourcify

  validates :name, presence: true, uniqueness: true

  def course_section_groups
    evaluations.no_missing_data.default_sorted_groups
  end

  def self.select_menu_options
    # pluck call must remain :name, :id to have the correct ordering for the select box helper
    instructors_with_evaluations_ids = Evaluation.uniq.pluck(:instructor_id)
    
    where(id: instructors_with_evaluations_ids).order(:name).pluck(:name, :id).push([ "New instructor...", 0 ])
  end

  def self.normalize_name(name)
    return nil unless name
    #put_last_name(name)
    name.split.map(&:capitalize).join(" ")
  end
end
