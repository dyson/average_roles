### Average Roles: Rails 4 roles based on a tree structure.

Add roles to models with tree structure via postgres_tree. It's average because it doesn't do much else.

[![Build Status](https://travis-ci.org/dyson/average_roles.svg?branch=master)](https://travis-ci.org/dyson/average_roles) [![Coverage Status](https://img.shields.io/coveralls/dyson/average_roles.svg)](https://coveralls.io/r/dyson/average_roles?branch=master) [![Gem Version](https://badge.fury.io/rb/average_roles.svg)](http://badge.fury.io/rb/average_roles)

----

#### Requirements

Gems:
* rails ~> 4.0
* postgres_tree ~> 0.0

#### Installation

##### Gemfile

Add to your Gemfile:

```ruby
gem 'average_roles'
```

Or lock it to the current backwards compatible version:

```ruby
gem 'average_roles', '~> 0.0.1'
```

##### Migration

Create a table for the roles, a table for object that have roles, and a join table. For example:

```ruby
class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.string :identifier
      t.string :description
      t.integer :parent_id
      t.boolean :active

      t.timestamps
    end
  end

  add_index :roles, [:identifier, :parent_id, :active]
end
```
```ruby
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      ...
      t.timestamps
    end
  end
end
```
```ruby
class CreateRolesUsers < ActiveRecord::Migration
  def change
    create_table :roles_users do |t|
      t.integer :role_id, null: false
      t.integer :user_id, null: false
    end
  end

  add_index :roles_users, [:role_id, :user_id]
end
```

##### Model

Add the concerns to the role and object models:

```ruby
class Role < ActiveRecord::Base
  include AverageRoles::RoleConcern
end
```
```ruby
class User < ActiveRecord::Base
  include AverageRoles::UserConcern
end
```

##### Initializer

Add an initialiazer if you want to use different values than the defaults. The default values are shown below.

```ruby
AverageRoles.configure do |config|
  config.user_model = 'User'
  config.role_model = 'Role'
  config.super_user = nil # or role identifier as symbol, eg: :super_user
end
```

#### Methods

Methods are generated based on the role model configured. In the example above this is simply 'Role'. For all of the methods below, replace role with whatever model name you are using being careful of pluralisation.

* user.**roles_as** (type) - Get roles of object by type (:identifiers, :ids, :objects)
* user.**has_role?** (role) - Check if object has role (can be a role identifier as a symbol, a role id, or a role object and returns True/False)
* user.**has_roles?** (roles) - Check if object has all roles (can be a list of role identifiers as a symbol, a list of role ids, or a list of role objects and returns True/False)
* user.**has_at_least_one_role?** (roles) - Check if object has at least one role (can be a list of role identifiers as a symbol, a list of role ids, or a list of role objects and returns True/False)

* user.**roles_and_descendents_as** (type)- Get roles and descendent roles of object by type (:identifiers, :ids, :objects)
* user.**has_role_by_descendents?** (role) - Check if object has role or a ancestors ancestor role (can be a role identifier as a symbol, a role id, or a role object and returns True/False)
* user.**has_roles_by_descendents?** (roles) - Check if object has all roles or at least a ancestor of each role (can be a list of role identifiers as a symbol, a list of role ids, or a list of role objects and returns True/False
* user.**has_at_least_one_role_by_descendents?** (role) - Check if object has at least one role or at least one ancestor of one role (can be a list of role identifiers as a symbol, a list of role ids, or a list of role objects and returns True/False)

#### Super User

If config.super_user is not set to nil and is set to a roles identifies as a symbol, then all of the has methods will always return true for a user with this role. For example, if you have a :super_user role, and assign it to a user, that user does not need any other roles added to them as they will return true no matter what role or roles you check they have. If you want to use this, but still do something based on someone having a specific role, you will need to test for both the role and for the :super_user role. For example:

```ruby
if user.has_role? :manager
  # True for managers and super users
end

if user.has_role?(:manager) and not user.has_role?(AverageRoles.configuration.super_user)
  # True for managers only
end
```

#### License

The MIT License (MIT)

Copyright 2014 Dyson Simmons

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
