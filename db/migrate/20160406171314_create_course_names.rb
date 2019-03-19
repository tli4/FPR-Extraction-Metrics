class CreateCourseNames < ActiveRecord::Migration
  def change
    create_table :course_names do |t|
      t.string :subject_course
      t.string :name

      t.timestamps
    end
  end
end
