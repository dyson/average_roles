require "average_roles/engine"
require "average_roles/models/concerns/role"
require "average_roles/models/concerns/user"

module AverageRoles

  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :user_model, :role_model, :super_user

    def initialize
      @user_model = 'User'
      @role_model = 'Role'
      @super_user = nil
    end
  end

end
