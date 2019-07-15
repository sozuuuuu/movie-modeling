require 'minitest/autorun'
require './src/main'

class TestMain < Minitest::Test
  def test_run
    assert_equal(1_900, Main.new.())
    assert_equal(1_500,
      Main.new(:university_student).(),
      'it should return \1500 if the user is university student')
    assert_equal(1_000,
      Main.new(:high_school_student).(),
      'it should return \1000 if the user is high school student')
  end
end
