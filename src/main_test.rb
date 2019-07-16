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
    assert_equal([2_300],
      Main.new([:none], :three_d).(),
      'it should cost extra \400 if requested movie is 3D')
    assert_equal([1_300],
      Main.new(:none, :standard, '2019-07-16T17:30:00').(),
      'it should return [¥1300] when the movie starts at 17:30 and it is not a holiday')
  end
end
