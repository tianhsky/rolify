require 'rolify/adapters/base'

module Rolify
  module Adapter
    class ResourceAdapter < ResourceAdapterBase
      def resources_find(roles_table, relation, role_name)
        if role_name.nil?
          roles = roles_table.classify.constantize.where(:resource_type => relation.to_s)
        else
          roles = roles_table.classify.constantize.where(:name.in => Array(role_name), :resource_type => relation.to_s)
        end
        
        resources = []
        roles.each do |role|
          if role.resource_id.nil?
            resources += relation.all
          else
            resources << role.resource
          end
        end
        resources.compact.uniq
      end

      def in(resources, user, role_names)
        unless role_names.nil
          roles = user.roles.where(:name.in => Array(role_names))
        end
        return [] if resources.empty? || roles.empty?
        resources.delete_if { |resource| (resource.applied_roles & roles).empty? }
        resources
      end
    end
  end
end