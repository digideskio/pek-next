class AuthSchServicesController < ApplicationController

  def sync
    user = get_user(params[:id], [])
    if user
      render json: { success: true, user: user_json(user) }
    end
  end

  def memberships
    user = get_user(params[:id], [ :groups, { memberships: [ { posts: [ :post_type ] } ] } ])
    if user
      render json: { success: true, memberships: membership_json(user) }
    end
  end

  def entrants
    user = get_user(params[:id], [ { entryrequests: [ :evaluation ] } ])
    if user
      render json: entrants_json(user, params[:semester])
    end
  end

private

  def entrants_json(user, semester)
    entrants = user.entryrequests.select { |er| er.evaluation.accepted && er.evaluation.semester == semester }
    entrant_array = []
    entrants.each do |entrant|
      entrant_array.push({
        groupId: entrant.evaluation.group_id,
        groupName: entrant.evaluation.group.name,
        entrantType: entrant.entry_type
        })
    end
    entrant_array
  end

  def membership_json(user)
    memberships_array = []
    user.memberships.each do |membership|
      memberships_array.push({
        start: membership.start,
        end: membership.end,
        group_name: membership.group.name,
        group_id: membership.group.id,
        posts: membership.posts.map { |p| p.post_type.name }
        })
      memberships_array.last[:posts].push(membership.end ? 'öregtag' : 'tag')
    end
    memberships_array
  end

  def user_json(user)
    {
      displayName: user.full_name,
      mail: user.email,
      givenName: user.firstname,
      sn: user.lastname,
      eduPersonNickName: user.nickname,
      uid: user.screen_name,
      mobile: user.cell_phone,
      schacPersonalUniqueId: user.id
    }.compact
  end

  def get_user(id, includes)
    type = id_type(id)
    error_response(400, 'Not valid id. It should be a UUID or a NEPTUN code.') if type == :invalid
    user = User.includes(includes)
      .find_by({ type => id.upcase })
    error_response(404, "Could not find user with #{id} id.") if !user
    user
  end

  def id_type(id)
    neptun_regex = /^[A-Za-z0-9]{6,7}$/
    uuid_regex = /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/
    return :neptun if id =~ neptun_regex
    return :auth_sch_id if id =~ uuid_regex
    :invalid
  end

  def error_response(error_code, message)
    msg = { success: false, message: message }
    render json: msg, status: error_code
  end

end