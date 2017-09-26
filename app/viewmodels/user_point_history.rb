class UserPointHistory

  def initialize(point)
    @point = point
  end

  def point
    @point.point
  end

  def semester
    @point.decorate.semester
  end

end