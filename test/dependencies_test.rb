require 'test_helper'

class DependenciesTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Nite::Dependencies
  end

  def setup
    @u1 = Unit.new(id: 1)
    @u2 = Unit.new(id: 2)
    @u3 = Unit.new(id: 3)
    @u4 = Unit.new(id: 4)
  end

  def teardown
    Unit.delete_all
    Item.delete_all
    Nite::Dependency.delete_all
  end

  def test_dependencies_is_empty_if_non_defined
    u = Unit.new(id: 1)
    assert_equal [], u.dependencies
  end

  def test_creation_of_dependency_succeeds_if_args_are_legal
    assert_nothing_raised do
      Nite::Dependency.add(@u1, @u2)
    end
    assert_equal 1, Nite::Dependency.count
  end

  def test_creation_of_dependency_fails_if_class_do_not_agree
    u = Unit.new(id: 1)
    i = Item.new(id: 1)
    assert_raises do
      Nite::Dependency.add(u, i)
    end
    assert_equal 0, Nite::Dependency.count
  end

  def test_creation_of_dependency_fails_if_ids_are_the_same
    u1 = Unit.new(id: 1)
    u2 = Unit.new(id: 1)
    assert_raises do
      Nite::Dependency.add(u1, u2)
    end
    assert_equal 0, Nite::Dependency.count
  end

  def test_creation_of_dependency_fails_if_added_twice
    v = Nite::Dependency.add(@u1, @u2)
    assert v.valid?
    v = Nite::Dependency.add(@u1, @u2)
    assert_not v.valid?
    assert_equal 1, Nite::Dependency.count
  end

  def test_creation_of_two_sets_of_dependencies_succeeds
    Nite::Dependency.add(@u1, @u2)
    Nite::Dependency.add(@u3, @u4)
    assert_equal 2, Nite::Dependency.count
  end

  def test_order_of_parameters_does_not_matter
    d1 = Nite::Dependency.add(@u1, @u2)
    d2 = Nite::Dependency.add(@u4, @u3)
    assert_equal d1.dependentable_a_id, @u1.id
    assert_equal d1.dependentable_b_id, @u2.id
    assert_equal d2.dependentable_a_id, @u3.id
    assert_equal d2.dependentable_b_id, @u4.id
  end

  def test_add_dependecy_via_model
    u1 = Unit.create
    u2 = Unit.create
    u1.add_dependency(u2)
    assert u1.dependencies.include? u2
    assert u2.dependencies.include? u1
  end

  def test_add_multiple_dependencies_via_model
    u1 = Unit.create
    u2 = Unit.create
    u3 = Unit.create

    u1.add_dependency(u2, u3)
    assert u1.dependencies.include? u2
    assert u1.dependencies.include? u3
  end

  def test_dependent_getter_on_model
    u1 = Unit.create
    u2 = Unit.create
    u3 = Unit.create

    u1.add_dependency(u2)
    assert u1.dependent?(u2)
    assert_not u1.dependent?(u3)
  end

  def test_depndencies_of_collection
    u1 = Unit.create
    u2 = Unit.create
    u3 = Unit.create
    u4 = Unit.create
    u1.add_dependency(u2)
    u3.add_dependency(u4)
    calulated_dependecies = Nite::Dependency.for_collection([u1,u3])
    expected_depndencies = [u2, u4]
    assert_equal expected_depndencies.sort, calulated_dependecies.sort
  end
end
