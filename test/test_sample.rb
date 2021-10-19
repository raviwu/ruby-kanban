require "minitest/autorun"
require_relative "../app/sample"

class TestSample < Minitest::Test
  def setup
    @sample = Sample.new
  end

  def test_that_kitty_can_eat
    assert_equal "OHAI!", @sample.i_can_has_cheezburger?
  end

  def test_that_it_will_not_blend
    refute_match (/^no/i), @sample.will_it_blend?
  end

  def test_that_will_be_skipped
    skip "test this later"
  end
end