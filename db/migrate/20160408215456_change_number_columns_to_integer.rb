class ChangeNumberColumnsToInteger < ActiveRecord::Migration
  def change
    prev_data = Evaluation.pluck(:id, :course, :section)

    remove_column :evaluations, :course
    remove_column :evaluations, :section
    add_column :evaluations, :course, :integer
    add_column :evaluations, :section, :integer

    prev_data.each do |data|
      Evaluation.find(data[0]).update(course: data[1].to_i, section: data[2].to_i)
    end
  end
end
