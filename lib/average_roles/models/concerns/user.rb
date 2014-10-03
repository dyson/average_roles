require 'active_support/concern'

module AverageRoles::UserConcern

  # TODO: Add a super user identifier that always returns true when checking if has role. This needs
  #       to be a configuration option.

  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many AverageRoles.configuration.role_model.downcase.pluralize.to_sym

    # Get roles by type
    define_method AverageRoles.configuration.role_model.downcase.pluralize + '_as' do |type|
      average_roles_check_type type
      case type
      when :identifiers
        roles = []
        self.send(AverageRoles.configuration.role_model.downcase.pluralize.to_sym).where(active: true).load.each do |role|
          roles << role.identifier.to_sym
        end
        roles
      when :ids
        return self.send (AverageRoles.configuration.role_model.downcase + '_ids').to_sym
      when :objects
        return self.send AverageRoles.configuration.role_model.downcase.pluralize.to_sym
      end
    end

    # Check if has role
    define_method 'has_' + AverageRoles.configuration.role_model.downcase + '?' do |role|
      return true if average_roles_has_super_user?
      if role.is_a? Symbol
        self.roles_as(:identifiers).include? role
      elsif role.is_a? Numeric
        self.send(AverageRoles.configuration.role_model.downcase + '_ids').include? role
      elsif role.is_a? AverageRoles.configuration.role_model.constantize.new.class
        self.send(AverageRoles.configuration.role_model.downcase + '_ids').include? role.id
      else
        raise ArgumentError, "Role must be a symbol, number or object of same type"
      end
    end

    # Check if has all roles
    define_method 'has_' + AverageRoles.configuration.role_model.downcase.pluralize + '?' do |roles|
      return true if average_roles_has_super_user?
      roles.each do |role|
        return false unless self.has_role? role
      end
      true
    end

    # Check if has at least one role
    define_method 'has_at_least_one_' + AverageRoles.configuration.role_model.downcase + '?' do |roles|
      return true if average_roles_has_super_user?
      roles.each do |role|
        return true if self.has_role? role
      end
      false
    end

    # Get roles and descendent roles by type
    define_method AverageRoles.configuration.role_model.downcase.pluralize + '_and_descendents_as' do |type|
      average_roles_check_type type
      roles = []
      self.send(AverageRoles.configuration.role_model.pluralize.downcase.to_sym).where(active: true).load.each do |role|
        role.self_and_descendents.each do |r|
          case type
          when :identifiers
            roles << r.identifier.to_sym
          when :ids
            roles << r.id
          when :objects
            roles << r
          end
        end
      end
      roles.uniq
    end

    # Check if object has role or a ancestors ancestor role
    define_method 'has_' + AverageRoles.configuration.role_model.downcase + '_by_descendents?' do |role|
      return true if average_roles_has_super_user?
      if role.is_a? Symbol
        self.roles_and_descendents_as(:identifiers).include? role
      elsif role.is_a? Numeric
        self.roles_and_descendents_as(:ids).include? role
      elsif role.is_a? AverageRoles.configuration.role_model.constantize.new.class
        self.roles_and_descendents_as(:ids).include? role.id # Use ids to save some memory
      else
        raise ArgumentError, "Role must be a symbol, number or object of same type"
      end
    end

    # Check if has all roles or at least a ancestor of each role
    define_method 'has_' + AverageRoles.configuration.role_model.downcase.pluralize + '_by_descendents?' do |roles|
      return true if average_roles_has_super_user?
      roles.each do |role|
        return false unless self.has_role_by_descendents? role
      end
      true
    end

    # Check if has at least one role or at least one ancestor of one role
    define_method 'has_at_least_one_' + AverageRoles.configuration.role_model.downcase + '_by_descendents?' do |roles|
      return true if average_roles_has_super_user?
      roles.each do |role|
        return true if self.has_role_by_descendents? role
      end
      false
    end

  end

  private

    # check type
    def average_roles_check_type(type)
      if not [:identifiers, :ids, :objects].include? type
        raise ArgumentError, "Type must be :identifiers, :ids or :objects"
      end
    end

    # check if the user has the super user role
    def average_roles_has_super_user?
      return self.roles_as(:identifiers).include?(AverageRoles.configuration.super_user) unless AverageRoles.configuration.super_user == nil
      return false
    end

end
