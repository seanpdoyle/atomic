require 'test_helper'

class Atomic::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Atomic
  end
end
