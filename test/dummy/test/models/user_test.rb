require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # Test that we actually have fixtures loaded
  test "user fixtures loaded" do
    record = User.first
    refute record == nil
  end

  # Relationships
  test "no roles" do
    record = User.find_by name: 'No Roles'
    refute record.roles.present?
  end

  test "roles" do
    record = User.find_by name: 'Administrator'
    assert record.roles.present?
  end

  # Base methods
  test "responds to all methods" do
    record = User.first
    assert_respond_to record, :roles_as
    assert_respond_to record, :has_role?
    assert_respond_to record, :has_roles?
    assert_respond_to record, :has_at_least_one_role?
  end


  # Getting roles
  test "get roles as" do
    record = User.find_by name: 'Administrator'
    role = Role.find_by identifier: 'administrator'
    assert_equal [:administrator], record.roles_as(:identifiers)
    assert_equal [role.id], record.roles_as(:ids)
    assert_equal [role], record.roles_as(:objects)

    record = User.find_by name: 'No Roles'
    assert_equal [], record.roles_as(:identifiers)
    assert_equal [], record.roles_as(:ids)
    assert_equal [], record.roles_as(:objects)
  end

  # Testing for role
  test "has role?" do
    record = User.find_by name: 'Administrator'
    role = Role.find_by identifier: 'administrator'
    assert record.has_role?(:administrator)
    assert record.has_role?(role.id)
    assert record.has_role?(role)

    role = Role.find_by identifier: 'guest'
    refute record.has_role?(:guest)
    refute record.has_role?(role.id)
    refute record.has_role?(role)

    record = User.find_by name: 'Super User'
    assert record.has_role?(:guest)
    assert record.has_role?(role.id)
    assert record.has_role?(role)
  end

  # Testing for roles
  test "has roles?" do
    record = User.find_by name: 'User'
    role_user = Role.find_by identifier: 'user'
    role_guest = Role.find_by identifier: 'guest'
    assert record.has_roles?([:user, :guest])
    assert record.has_roles?([role_user.id, role_guest.id])
    assert record.has_roles?([role_user, role_guest])

    role_adminstrator = Role.find_by identifier: 'administrator'
    refute record.has_roles?([:user, :guest, :administrator])
    refute record.has_roles?([role_user.id, role_guest.id, role_adminstrator.id])
    refute record.has_roles?([role_user, role_guest, role_adminstrator])

    record = User.find_by name: 'Super User'
    assert record.has_roles?([:user, :guest])
    assert record.has_roles?([role_user.id, role_guest.id])
    assert record.has_roles?([role_user, role_guest])
  end

  # Testing for at least one role
  test "has at least one role?" do
    record = User.find_by name: 'Guest'
    role_user = Role.find_by identifier: 'user'
    role_guest = Role.find_by identifier: 'guest'
    assert record.has_at_least_one_role?([:user, :guest])
    assert record.has_at_least_one_role?([role_user.id, role_guest.id])
    assert record.has_at_least_one_role?([role_user, role_guest])

    record = User.find_by name: 'Administrator'
    refute record.has_at_least_one_role?([:user, :guest])
    refute record.has_at_least_one_role?([role_user.id, role_guest.id])
    refute record.has_at_least_one_role?([role_user, role_guest])

    record = User.find_by name: 'Super User'
    assert record.has_at_least_one_role?([:user, :guest])
    assert record.has_at_least_one_role?([role_user.id, role_guest.id])
    assert record.has_at_least_one_role?([role_user, role_guest])
  end

  # Getting roles and decendents of roles
  test "get roles and descendents as" do
    record = User.find_by name: 'Administrator'
    role_administrator = Role.find_by identifier: 'administrator'
    role_user = Role.find_by identifier: 'user'
    role_guest = Role.find_by identifier: 'guest'
    assert_equal [:administrator, :user, :guest], record.roles_and_descendents_as(:identifiers)
    assert_equal [role_administrator.id, role_user.id, role_guest.id], record.roles_and_descendents_as(:ids)
    assert_equal [role_administrator, role_user, role_guest], record.roles_and_descendents_as(:objects)

    record = User.find_by name: 'No Roles'
    assert_equal [], record.roles_and_descendents_as(:identifiers)
    assert_equal [], record.roles_and_descendents_as(:ids)
    assert_equal [], record.roles_and_descendents_as(:objects)
  end

  # Testing for role by descendents
  test "has role by descendents?" do
    record = User.find_by name: 'Administrator'
    role = Role.find_by identifier: 'guest'
    assert record.has_role_by_descendents?(:guest)
    assert record.has_role_by_descendents?(role.id)
    assert record.has_role_by_descendents?(role)

    record = User.find_by name: 'User'
    role = Role.find_by identifier: 'administrator'
    refute record.has_role_by_descendents?(:administrator)
    refute record.has_role_by_descendents?(role.id)
    refute record.has_role_by_descendents?(role)

    record = User.find_by name: 'Super User'
    assert record.has_role_by_descendents?(:administrator)
    assert record.has_role_by_descendents?(role.id)
    assert record.has_role_by_descendents?(role)
  end

  # Testing for roles by descendents
  test "has roles by descendents?" do
    record = User.find_by name: 'Administrator'
    role_user = Role.find_by identifier: 'user'
    role_guest = Role.find_by identifier: 'guest'
    assert record.has_roles_by_descendents?([:user, :guest])
    assert record.has_roles_by_descendents?([role_user.id, role_guest.id])
    assert record.has_roles_by_descendents?([role_user, role_guest])

    record = User.find_by name: 'User'
    role_administrator = Role.find_by identifier: 'administrator'
    role_guest = Role.find_by identifier: 'guest'
    refute record.has_roles_by_descendents?([:administrator, :guest])
    refute record.has_roles_by_descendents?([role_administrator.id, role_guest.id])
    refute record.has_roles_by_descendents?([role_administrator, role_guest])

    record = User.find_by name: 'Super User'
    assert record.has_roles_by_descendents?([:user, :guest])
    assert record.has_roles_by_descendents?([role_user.id, role_guest.id])
    assert record.has_roles_by_descendents?([role_user, role_guest])
  end

  # Testing has at least one role by descendents
  test "has at least one role by descendents?" do
    record = User.find_by name: 'User'
    role_administrator = Role.find_by identifier: 'administrator'
    role_guest = Role.find_by identifier: 'guest'
    assert record.has_at_least_one_role_by_descendents?([:administrator, :guest])
    assert record.has_at_least_one_role_by_descendents?([role_administrator.id, role_guest.id])
    assert record.has_at_least_one_role_by_descendents?([role_administrator, role_guest])

    record = User.find_by name: 'Guest'
    role_administrator = Role.find_by identifier: 'administrator'
    role_user = Role.find_by identifier: 'user'
    refute record.has_at_least_one_role_by_descendents?([:administrator, :user])
    refute record.has_at_least_one_role_by_descendents?([role_administrator.id, role_user.id])
    refute record.has_at_least_one_role_by_descendents?([role_administrator, role_user])

    record = User.find_by name: 'Super User'
    assert record.has_at_least_one_role_by_descendents?([:administrator, :guest])
    assert record.has_at_least_one_role_by_descendents?([role_administrator.id, role_guest.id])
    assert record.has_at_least_one_role_by_descendents?([role_administrator, role_guest])
  end
end
