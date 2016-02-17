require 'test_helper'

class DependenciesTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Nite::Dependencies
  end

  def test_dependencies_is_empty_if_non_defined
    u = Unit.create(number:1)
    assert_equal [], u.dependencies
  end
end
