module Nite
  module Dependencies
    module HasDependencies
      extend ActiveSupport::Concern

      included do
      end

      module ClassMethods

        def has_dependencies(options={})
          #puts "class is #{self}"
          include Nite::Dependencies::HasDependencies::LocalInstanceMethods
        end

      end

      module LocalInstanceMethods
        # getters - fetch all dependecies of self
        def dependencies
          klass = self.class

          join_clause = <<-QUERY
              INNER JOIN dependencies
              ON (dependentable_type=\"#{klass}\" 
              AND ((dependentable_a_id = #{self.id}) OR
              (dependentable_b_id = #{self.id})))
          QUERY

          klass.joins(join_clause)

        end

        def dependent?(elem)
          Dependency.dependent?(self, elem)
        end

        # setters
        def add_dependency(*args)
          args.each do |element|
            if(self.class != element.class)
              raise "Dependecy allowed only for objects of the same class: #{self} <--> #{element}"
            end

            Dependency.add(self, element)

          end
        end

      end
    end
  end
end

ActiveRecord::Base.send :include, Nite::Dependencies::HasDependencies
