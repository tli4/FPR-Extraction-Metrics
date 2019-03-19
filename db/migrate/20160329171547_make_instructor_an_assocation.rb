class MakeInstructorAnAssocation < ActiveRecord::Migration
  def change
    instructors = Evaluation.uniq.pluck(:instructor)

    rename_column :evaluations, :instructor, :instructor_name

    change_table :evaluations do |t|
      t.belongs_to :instructor, index: true
    end

    instructors.each do |instructor_name|
      i = Instructor.create(name: instructor_name)
      Evaluation.where(instructor_name: instructor_name).update_all(instructor_id: i)
    end

    remove_column :evaluations, :instructor_name
  end
end
