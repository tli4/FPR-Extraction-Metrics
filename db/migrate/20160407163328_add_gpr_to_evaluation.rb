class AddGprToEvaluation < ActiveRecord::Migration
  def up
    add_column :evaluations, :gpr, :decimal
  end

  def down
    remove_column :evaluations, :gpr
  end
end
