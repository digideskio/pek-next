class PointHistoryDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def semester
    semester = point_history.semester
    semester.starting_year.to_s + "/" + semester.second_year.to_s + " " + (semester.autumn ? "ősz" : "tavasz")
  end

end
