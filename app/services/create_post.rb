class CreatePost

  def self.call(group, membership, post_type_id)
    Post.create(grp_member_id: membership.id, post_type_id: post_type_id)
    check_leader_reassign(group, post_type_id)
  end

  def self.check_leader_reassign(group, post_type_id)
    if post_type_id == Membership::LEADER_POST_ID
      Post.create(grp_member_id: group.leader.id, post_type_id: Membership::PAST_LEADER_ID)
      group.leader.post(Membership::LEADER_POST_ID).destroy
      return true
    end
  end

end
