class AddStatusToInstructors < ActiveRecord::Migration
  def change
    add_column :instructors, :status, :string
  end
end
