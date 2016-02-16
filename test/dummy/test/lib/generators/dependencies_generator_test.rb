require 'test_helper'
require 'generators/dependencies/dependencies_generator'

class DependenciesGeneratorTest < Rails::Generators::TestCase
  tests DependenciesGenerator
  destination Rails.root.join('tmp/generators')
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
