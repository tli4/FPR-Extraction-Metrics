class CreateEvaluations < ActiveRecord::Migration
  def up
    create_table :evaluations do |t|
      t.string :term
      t.string :subject
      t.string :course
      t.string :section
      t.string :instructor
      t.integer :enrollment
      (1..8).each do |num|
        t.decimal "item#{num}_mean".to_sym
      end
      t.timestamps
    end
  end

  def down
    drop_table :evaluations
  end
end
