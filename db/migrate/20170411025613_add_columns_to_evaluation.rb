class AddColumnsToEvaluation < ActiveRecord::Migration
  def change
    add_column :evaluations, :mses, :decimal
    add_column :evaluations, :dae, :decimal
    add_column :evaluations, :ang, :string
    add_column :evaluations, :dang, :decimal
    add_column :evaluations, :history, :integer
    
  end
end
