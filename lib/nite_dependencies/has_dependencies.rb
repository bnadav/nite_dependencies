# === Example
#
#   class Item < ActiveRecord::Base
#     has_dependencies
#   end
#
#   ia = Item.create
#   ib = Item.create
#
#   ia.dependencies # => []
#   ia.add_dependency(ib)
#   ia.dependencies # => [ib]
#   ia.dependent? ib # => true
#   ia.dependent? (Item.create) # => false
module Nite
  module Dependencies
    module HasDependencies
      extend ActiveSupport::Concern

      included do
      end

      module ClassMethods

        # Class method included into AR::Base
        # When called it includes some the instance methods in LocalInstanceMethods module
        # into the including class
        #
        def has_dependencies(options={})
          #puts "class is #{self}"
          include Nite::Dependencies::HasDependencies::LocalInstanceMethods
        end

      end

      module LocalInstanceMethods
        include ActiveSupport::Inflector 
        # getters - fetch all dependecies of self
        def dependencies
          klass = self.class

          tableized_id = klass.to_s.tableize + ".id"

          join_clause = <<-QUERY
              INNER JOIN nite_dependencies 
              ON ((#{tableized_id}=dependentable_a_id) OR (#{tableized_id}=dependentable_b_id)) 
              AND (dependentable_type=\"#{klass}\" AND ((dependentable_a_id = #{self.id}) OR (dependentable_b_id = #{self.id})))
          QUERY

          klass.where("#{tableized_id}!=#{self.id}").joins(join_clause)

        end

        # Boolean check of dependency of seld with some object
        def dependent?(elem)
          Nite::Dependency.dependent?(self, elem)
        end

        # setters - create new dependencies between self and objects passed as params
        def add_dependency(*args)
          args.each do |element|
            if(self.class != element.class)
              raise "Dependecy allowed only for objects of the same class: #{self} <--> #{element}"
            end

            Nite::Dependency.add(self, element)

          end
        end

      end
    end
  end
end

ActiveRecord::Base.send :include, Nite::Dependencies::HasDependencies
