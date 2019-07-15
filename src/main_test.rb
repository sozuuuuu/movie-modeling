require 'minitest/autorun'
require './src/main'

class TestMain < Minitest::Test
  def test_run
    assert_equal([1_900], Main.new.())
    assert_equal([1_500],
      Main.new(:university_student).(),
      'it should return \1500 if the user is a university student')
    assert_equal([1_000],
      Main.new(:high_school_student).(),
      'it should return \1000 if the user is a high school student')
    assert_equal([1_000],
      Main.new(:child).(),
      'it should return \1000 if the user is a child')
    assert_equal([1_000],
      Main.new(:handicapped).(),
      'it should return \1000 if the uset is a handicapped')
    assert_equal([1_000, 1_000],
      Main.new([:handicapped, :none]).call,
      'it should return [\1000, \1000] if one of the users is a handicapped with oen attendant')
    assert_equal([1_000, 1_000, 1_900],
      Main.new([:handicapped, :none, :none]).call,
      'it should return [\1000, \1000, \1900] if one of the users is a handicapped with more than one attendant')
  end
end
