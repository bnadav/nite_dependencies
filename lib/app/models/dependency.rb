class Dependency < ActiveRecord::Base

  # validates uniqness within dependentable_type
  validates :dependentable_a_id, uniqueness: { scope: [:dependentable_type, :dependentable_b_id] }

  # .add(first, second)
  # Add a dependency of first and second element.
  # first and second objects should be model instances of the same class, with differnt ids.
  # The method creates a dependency in which the fields are set in the following way:
  #   dependentable_type: the class of the models
  #   dependentable_a_id: the smaller id of the the models ids
  #   dependentable_b_id: the larger id of the the models ids
  def self.add(first, second)
    if first.id == second.id
      raise "Can not add self dependency for #{first} and #{second}" 
    end
    if first.class != second.class
      raise "Dependecy allowed only for objects of the same class: #{first} <--> #{second}"
    end
    ordered = self.order_elements(first, second)

    self.create(dependentable_type: first.class, dependentable_a_id: ordered.first.id, 
                dependentable_b_id: ordered.last.id)
  end

  def self.dependent?(first, second)
    return false unless self.same_class?(first, second)
    return false if self.same_id?(first, second)
    ordered = self.order_elements(first, second)
    Dependency.where(dependentable_type: first.class, dependentable_a_id: ordered.first.id,
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
