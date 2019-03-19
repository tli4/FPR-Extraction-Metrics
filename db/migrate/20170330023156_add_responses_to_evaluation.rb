class AddResponsesToEvaluation < ActiveRecord::Migration
  def change
    add_column :evaluations, :responses, :integer
  end
end
