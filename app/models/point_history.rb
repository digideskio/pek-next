class PointHistory < ActiveRecord::Base
  self.table_name = "point_history"
  self.primary_key = :id

  belongs_to :user, foreign_key: :usr_id

  def semester
    Semester.new(read_attribute(:semester))
  end
end
