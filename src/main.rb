class Main
  PRICE_1000_ATTRS = [:high_school_student, :child, :handicapped]

  def initialize(user_attrs = [:none])
    @user_attrs = user_attrs.is_a?(Array) ? user_attrs : [user_attrs]
  end

  def call
    # No instance variable definition outside of constructor!
    @result = @user_attrs.map do |attr|
      next 1500 if attr == :university_student
      next 1000 if PRICE_1000_ATTRS.include?(attr)
      1900
    end
    return handicapped_attendant_discount if @user_attrs.include?(:handicapped)
    @result
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
end
