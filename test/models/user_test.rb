# frozen_string_literal: true

require 'test_helper'

class UsersTest < ActiveSupport::TestCase
  test '#name_or_email if a user does not have a name, the users email must be returned' do
    user = User.new(email: 'sample@example.com')
    assert_equal 'sample@example.com', user.name_or_email
  end

  test '#name_or_email if the user has a name, it must be returned' do
    user = User.new(email: 'sample@example.com', name: 'sample_name')
    assert_equal 'sample_name', user.name_or_email
  end
end
