class Main
  def initialize(user_attr = nil)
    @user_attr = user_attr
  end

  def call
    return 1500 if @user_attr == :university_student
    return 1000 if @user_attr == :high_school_student || @user_attr == :child
    1900
  end
end
