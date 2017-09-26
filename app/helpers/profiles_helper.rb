module ProfilesHelper
  def own_memberships
    @user_presenter.memberships.order(end: :desc).includes(:group).each do |membership|
      yield GroupMember.new(membership)
    end
  end

  def own_point_histories
    @user_presenter.point_histories.order(semester: :asc).each do |point_history|
      @point_history = point_history.decorate
      yield UserPointHistory.new(@point_history)
    end
  end
end
