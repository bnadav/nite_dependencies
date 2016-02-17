class CreateNiteDependencies < ActiveRecord::Migration

  def self.change
    create_table :nite_dependencies do |t|
      t.string :dependentable_type

      t.integer :dependentable_a_id;

      t.integer :dependentable_b_id;

      t.timestamps

    end
  end

end
