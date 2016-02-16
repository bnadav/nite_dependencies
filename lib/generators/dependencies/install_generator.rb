# encoding: UTF-8
require 'rails/generators'

module Dependecies
  class InstallGenerator < Rails::Generators::Base
    desc "Generate migrations for Nite's dependencies gem"
    source_root File.expand_path('../templates', __FILE__)

    def migrations
      Rails.logger.info("Generating Migrations!!")
    end

  end
end
