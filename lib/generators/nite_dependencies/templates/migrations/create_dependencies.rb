class CreateDependencies < ActiveRecord::Migration

  def self.change
    create_table dependencies do |t|
      t.string :dependentable_type

      t.integer :dependentable_a_id;

      t.integer :dependentable_b_id;

      t.timestamps

    end
  end

end
