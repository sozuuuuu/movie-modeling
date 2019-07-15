require 'minitest/autorun'
require './src/main'

class TestMain < Minitest::Test
  def test_run
    assert_equal(1_900, Main.new.())
  end
end
