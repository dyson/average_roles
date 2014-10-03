require 'active_support/concern'

module AverageRoles::RoleConcern

  extend ActiveSupport::Concern

  included do
    include PostgresTree::ActiveRecordConcern

    has_and_belongs_to_many AverageRoles.configuration.user_model.downcase.pluralize.to_sym

    # Associations for tree
    belongs_to :parent, class_name: AverageRoles.configuration.role_model
    has_many :children, class_name: AverageRoles.configuration.role_model, foreign_key: 'parent_id'

    # Validations
    validates :name, presence: true, uniqueness: true
    validates :identifier, presence: true, uniqueness: true
    validates :description, presence: true
  end

end
