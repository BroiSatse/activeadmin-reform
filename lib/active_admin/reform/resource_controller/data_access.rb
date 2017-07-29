require 'reform'
require 'active_support/concern'

#
module ActiveAdmin
  #
  module Reform
    #
    module ResourceController
      # Overrides ActiveAdmin' templates method to wrap model into Reform::Form
      module DataAccess
        extend ActiveSupport::Concern

        def build_new_resource
          return super unless apply_form?
          model = scoped_collection.send method_for_build
          form = form_class.new(model)
          form.deserialize(*resource_params)
          form
        end

        def find_resource
          model = super
          return model unless apply_form?
          form_class.new(model)
        end

        def assign_attributes(resource, attributes)
          return super unless apply_form?
          resource.deserialize(*attributes)
        end
      end

      ::ActiveAdmin::ResourceController.send(:include, DataAccess)
    end
  end
end
