# encoding: UTF-8
require 'rails/generators'

module Nite
  module Dependencies
    class InstallGenerator < Rails::Generators::Base
      desc "Generate migrations for Nite's dependencies gem"
      source_root File.expand_path('../templates', __FILE__)

      DEPENDENCIES_MIGRATIONS = %w(
      create_nite_dependencies
      )

      def migrations
        Rails.logger.info("Generating Migrations!!")
        # increment migration timestamps to prevent collisions. copied functionality from RAILS_GEM_PATH/lib/rails_generator/commands.rb
        DEPENDENCIES_MIGRATIONS.each_with_index do |name, i|
          unless (prev_migrations = check_for_existing_migrations(name)).empty?
            prev_migration_timestamp = prev_migrations[0].match(/([0-9]+)_#{name}.rb$/)[1]
          end
          copy_file("migrations/#{name}.rb", "db/migrate/#{(prev_migration_timestamp || Time.now.utc.strftime("%Y%m%d%H%M%S").to_i + i).to_s}_#{name}.rb")
        end
      end


      private

      def check_for_existing_migrations(name)
        Dir.glob("db/migrate/[0-9]*_*.rb").grep(/[0-9]+_#{name}.rb$/)
      end

    end
  end
end
