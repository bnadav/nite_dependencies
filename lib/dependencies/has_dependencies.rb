module Dependencies
  module HasDependencies
    extend ActiveSupport::Concern

    included do
      Rails.logger.info(self)

    end

    module ClassMethods

      def has_dependencies(options={})
        include Dependencies::HasDependencies::LocalInstanceMethods
      end

    end

    module LocalInstanceMethods
        

    end
  end
end

ActiveRecord::Base.send :include, Dependencies::HasDependencies
