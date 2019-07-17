# frozen_string_literal: true

# typed: true
require 'date'
require 'holidays'
require 'holidays/core_extensions/date'
require 'sorbet-runtime'

class Date
  include Holidays::CoreExtensions::Date
end

class ArrayHelper
  def self.wrap(object)
    if object.nil?
      []
    elsif object.respond_to?(:to_ary)
      object.to_ary
    else
      [object]
    end
  end
end

class User < T::Struct
  prop :sex, T.nilable(Symbol)
  prop :handicapped, T::Boolean, default: false
  prop :student_type, T.nilable(Symbol), default: nil
  prop :is_child, T::Boolean, default: false
  prop :age, T.nilable(Integer), default: nil

  def self.build(attr)
    return build_with_single_symbol(attr) if attr.is_a?(Symbol)

    new(attr)
  end

  def self.build_with_single_symbol(attr)
    u = User.new
    u.handicapped = true if attr == :handicapped
    u.student_type = attr if %i[university_student high_school_student].include?(attr)
    u.is_child = true if attr == :child
    u
  end

  def child?
    is_child
  end

  def handicapped?
    handicapped
  end
end

class Users < Array
  def have_handicapped?
    any?(&:handicapped?)
  end
end

class Movie < T::Struct
  prop :starts_at, T.nilable(T.any(DateTime, String)), default: nil
  prop :type, Symbol, default: :standard

  def initialize(starts_at:, type:)
    super
    @starts_at = if @starts_at.is_a?(String)
                   DateTime.parse(@starts_at)
                 elsif @starts_at.is_a?(DateTime) || @starts_at.nil?
                   @starts_at
                 else
                   raise ArgumentError, 'Unrecognizable value passed to starts_at'
                 end
  end
end

class Main
  extend T::Sig

  PRICE_1000_ATTRS = %i[high_school_student child handicapped].freeze

  sig { params(user_attrs_or_user: T.any(Symbol, T::Array[Symbol], Hash), movie_type: Symbol, movie_starts_at: T.nilable(String)).void }
  def initialize(user_attrs_or_user = [:none], movie_type = :standard, movie_starts_at = nil)
    users = Users.new(ArrayHelper.wrap(user_attrs_or_user).map { |v| v.is_a?(User) ? v : User.build(v) })
    @users = T.let(users, Users)
    @movie = Movie.new(type: movie_type, starts_at: movie_starts_at)
    @result = T.let(nil, T.nilable(T::Array[Integer]))
  end

  sig { returns(T::Array[Integer]) }
  def standard_cost
    # No instance variable definition outside of constructor!
    @result = @users.map do |u|
      next 1000 if @movie.starts_at&.day == 1 && @movie.starts_at&.month == 12
      next 1000 if u.student_type == :high_school_student || u.child? || u.handicapped?
      next 1200 if u.sex == :female && @movie.starts_at&.wday == 3
      next 1200 if @movie.starts_at&.month != 12 && @movie.starts_at&.day == 1
      next 1200 if u.age&.>= 60
      next 1500 if u.student_type == :university_student

      1900
    end
    @result = handicapped_attendant_discount if @users.have_handicapped?
    @result = evening_discount if @movie.starts_at && (!@movie.starts_at.to_date.holiday?(:jp) && ('17:30'..'19:55').include?(@movie.starts_at.strftime('%H:%M')))
    @result
  end

  sig { returns(T::Array[Integer]) }
  def call
    return (standard_cost.map { |c| c + 400 }) if @movie.type == :three_d

    standard_cost
  end

  sig { returns(T::Array[Integer]) }
  def handicapped_attendant_discount
    # Bad code: stateful map
    discount_count = 1
    (@result || []).map do |r|
      if r > 1000 && discount_count > 0
        discount_count -= 1
        next 1000
      end
      r
    end
  end

  sig { returns(T::Array[Integer]) }
  def evening_discount
    (@result || []).map do |r|
      next 1300 if r > 1300

      r
    end
  end
end
