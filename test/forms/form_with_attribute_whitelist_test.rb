require 'test_helper'
require_relative '../fixtures/attribute_whitelist_form_fixture'

class FormWithAttributeWhitelistTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests
  fixtures :users

  def setup
    @user = User.new
    @form = AttributeWhitelistFormFixture.new(@user)
    @model = @form
  end

  test "accepts the model it represents" do
    assert_equal @user, @form.model
  end

  test "contains attrs array" do
    assert_equal [:name, :age, :gender], @form.attrs
    assert_equal false, @form.attrs.include?(:funny)
  end

  test "sync the model with submitted data" do
    params = {
      name: "Peters",
      age: "23",
      gender: "0",
      funny: true
    }

    @form.submit(params)

    assert_equal "Peters", @form.name
    assert_equal 23, @form.age
    assert_equal 0, @form.gender

    assert_equal ["unpermitted attribute: funny"], @form.whitelist_failures
  end
end