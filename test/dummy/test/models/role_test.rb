require 'test_helper'

class RoleTest < ActiveSupport::TestCase

  # Test that we actually have fixtures loaded
  test "role fixtures loaded" do
    record = Role.first
    refute record == nil
  end

  # Relationships
  test "parent relationship where no parent" do
    record = Role.find_by identifier: 'administrator'
    refute record.parent.present?
  end

  test "parent relationship where parent" do
    record = Role.find_by identifier: 'user'
    assert record.parent.present?
  end

  test "children relationship where no child" do
    record = Role.find_by identifier: 'guest'
    assert record.children.empty?
  end

  test "children relationship where child" do
    record = Role.find_by identifier: 'user'
    assert_equal 1, record.children.size
  end

  test "no users" do
    record = Role.find_by identifier: 'no_user'
    refute record.users.present?
  end

  test "users" do
    record = Role.find_by identifier: 'administrator'
    assert record.users.present?
  end

  # Validations
  test "unique name" do
    record = Role.new
    record.name = 'Administrator'
    record.identifier = 'admin'
    record.description = 'Another administrator account'
    refute record.save
  end

  test "unique identifier" do
    record = Role.new
    record.name = 'Admin'
    record.identifier = 'administrator'
    record.description = 'Another administrator account'
    refute record.save
  end

  test "has description" do
    record = Role.new
    record.name = 'Admin'
    record.identifier = 'admin'
    refute record.save
  end

  test "savable" do
    record = Role.new
    record.name = 'New'
    record.identifier = 'new'
    record.description = 'A new account'
    assert record.save
  end

  # Base methods
  test "responds to all methods" do
    record = Role.first
    assert_respond_to record, :parent
    assert_respond_to record, :children
  end

end
