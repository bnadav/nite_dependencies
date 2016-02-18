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
