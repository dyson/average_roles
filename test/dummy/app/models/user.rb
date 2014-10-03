class User < ActiveRecord::Base
  include AverageRoles::UserConcern
end
