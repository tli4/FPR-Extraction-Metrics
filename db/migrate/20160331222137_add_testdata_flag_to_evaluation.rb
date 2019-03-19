class AddTestdataFlagToEvaluation < ActiveRecord::Migration
  def up
    add_column :evaluations, :is_test_data, :boolean
    Evaluation.all.update_all(is_test_data: true)
  end

  def down
    remove_column :evaluations, :is_test_data
  end
end
