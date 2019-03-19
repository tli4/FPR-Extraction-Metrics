class AddExtraNameToInstructor < ActiveRecord::Migration
  def up
    add_column :instructors, :extra_name, :string
  end

  def down
    remove_column :instructors, :extra_name
  end
end
