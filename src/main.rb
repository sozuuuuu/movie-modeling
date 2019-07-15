class Main
  def initialize(user_attr = nil)
    @user_attr = user_attr
  end

  def call
    return 1500 if @user_attr == :university_student
    1900
  end
end
