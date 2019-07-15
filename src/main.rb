class Main
  PRICE_1000_ATTRS = [:high_school_student, :child, :handicapped]

  def initialize(user_attr = :none)
    @user_attr = user_attr
  end

  def call
    return 1500 if @user_attr == :university_student
    return 1000 if PRICE_1000_ATTRS.include?(@user_attr)
    1900
  end
end
