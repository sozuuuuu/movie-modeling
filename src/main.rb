require 'date'
require 'holidays'
require 'holidays/core_extensions/date'

class Date
  include Holidays::CoreExtensions::Date
end

class Main
  PRICE_1000_ATTRS = [:high_school_student, :child, :handicapped]

  def initialize(user_attrs = [:none], movie_type = :standard, movie_starts_at = nil)
    @user_attrs = user_attrs.is_a?(Array) ? user_attrs : [user_attrs]
    @movie_type = movie_type
    @movie_starts_at = movie_starts_at ? DateTime.parse(movie_starts_at) : nil
  end

  def standard_cost
    # No instance variable definition outside of constructor!
    @result = @user_attrs.map do |attr|
      next 1500 if attr == :university_student
      next 1000 if PRICE_1000_ATTRS.include?(attr)
      1900
    end
    @result = handicapped_attendant_discount if @user_attrs.include?(:handicapped)
    @result = evening_discount if @movie_starts_at && (!@movie_starts_at.to_date.holiday?(:jp) && ('17:30'..'19:55').include?(@movie_starts_at.strftime('%H:%M')))
    @result
  end

  def call
    return (standard_cost.map { |c| c + 400 }) if @movie_type == :three_d
    standard_cost
  end

  def handicapped_attendant_discount
    # Bad code: stateful map
    discount_count = 1
    @result.map do |r|
      if r > 1000 && discount_count > 0
        discount_count = discount_count - 1
        next 1000
      end
      r
    end
  end

  def evening_discount
    @result.map do |r|
      next 1300 if r > 1300
      r
    end
  end
end
