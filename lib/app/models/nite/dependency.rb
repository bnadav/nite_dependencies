module Nite
  # Dependency between two model objects of same class.
  # There are two class methods for creating a new depndency, and for
  # checking dependency existance.
  #
  # Errors are raised if the following cases:
  # * Trying to create a dependency between objects of different classes
  # * Trying to create a dependency between an object to itself (same id)
  # Validation of fails for duplicate dependencies
  class Dependency < ActiveRecord::Base
    extend ActiveSupport::Inflector 

    # prefix table with nite so it is nite_dependencies
    def self.table_name_prefix
      'nite_'
    end

    # validates uniqness within dependentable_type
    validates :dependentable_a_id, uniqueness: { scope: [:dependentable_type, :dependentable_b_id] }

    # Create a dependency between the first and the second elements.
    # Params should be model instances of the same class, with differnt ids.
    # The method creates a dependency in which the fields are set in the following way:
    #   dependentable_type: the class of the models
    #   dependentable_a_id: the smaller id of the the models ids
    #   dependentable_b_id: the larger id of the the models ids
    #
    # === Attributes
    # * +first+ - first model instance
    # * +second+ - second modle instance
    #
    # == Exceptions
    # Exceptions are raised if the two parameters belong to different classs or have the same id .
    def self.add(first, second)
      if same_id?(first, second)
        raise "Can not add self dependency for #{first} and #{second}" 
      end
      unless same_class?(first, second)
        raise "Dependecy allowed only for objects of the same class: #{first} <--> #{second}"
      end
      ordered = self.order_elements(first, second)

      self.create(dependentable_type: first.class, dependentable_a_id: ordered.first.id, 
                  dependentable_b_id: ordered.last.id)
    end

    # Check if the two given elements are dependent.
    # Return true if they are, and false if they aren't.
    # By convention an element is not dependent upon itself.
    #
    # ==== Attributes
    # * +first+ - first element
    # * +second+ - second element
    def self.dependent?(first, second)
      return false unless self.same_class?(first, second)
      return false if self.same_id?(first, second)
      ordered = self.order_elements(first, second)
      Nite::Dependency.where(dependentable_type: first.class, dependentable_a_id: ordered.first.id,
                       dependentable_b_id: ordered.last.id).size == 1

    end

    # Find dependencies of all elements in a given collection. Done via single database query.
    # All elements in the collectin must be of the same class or an exception will be raised.
    #
    # ==== Attributes
    # * +collection+ - collection of elements of the same class
    def self.for_collection(collection)
      return [] if collection.blank? # = nil? or empty?
      klass = collection.first.class
      if( collection.any?{|el| el.class != klass} )
        raise "Dependecies for collection require that all object classes in the collection will be the same"
      end

      klass_s = klass.to_s
      tableized_id = tableize(klass.to_s) + ".id"

      ids = collection.map(&:id).join(",")

      join_clause = <<-QUERY
              INNER JOIN nite_dependencies 
              ON ((#{tableized_id}=dependentable_a_id) OR (#{tableized_id}=dependentable_b_id)) 
              AND (dependentable_type=\"#{klass}\") AND ((dependentable_a_id IN (#{ids})) OR (dependentable_b_id IN (#{ids})))
      QUERY
      klass.where("#{tableized_id} NOT IN (#{ids})").joins(join_clause)

    end

    private

    def self.order_elements(first, second)
      (first.id < second.id) ? [first, second] : [second, first]
    end

    def self.same_class?(first, second)
      first.class == second.class
    end

    def self.same_id?(first, second)
      first.id == second.id
    end

  end
end
