class Role < ActiveRecord::Base
  include AverageRoles::RoleConcern
end
