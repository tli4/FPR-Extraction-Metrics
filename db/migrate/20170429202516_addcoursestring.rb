class Addcoursestring < ActiveRecord::Migration
  def change
    add_column :evaluations, :coursestring, :string
  end
end
