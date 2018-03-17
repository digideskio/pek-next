class Group < ActiveRecord::Base
  self.primary_key = :grp_id

  alias_attribute :id, :grp_id
  alias_attribute :name, :grp_name
  alias_attribute :type, :grp_type
  alias_attribute :parent, :grp_parent
  alias_attribute :state, :grp_state
  alias_attribute :description, :grp_description
  alias_attribute :webpage, :grp_webpage
  alias_attribute :maillist, :grp_maillist
  alias_attribute :head, :grp_head
  alias_attribute :founded, :grp_founded
  alias_attribute :issvie, :grp_issvie
  alias_attribute :delegate_count, :grp_svie_delegate_nr
  alias_attribute :users_can_apply, :grp_users_can_apply
  alias_attribute :archived_members_visible, :grp_archived_members_visible

  has_many :memberships, foreign_key: :grp_id
  has_many :members, through: :memberships, source: :user
  has_many :post_types, foreign_key: :grp_id
  alias :own_post_types :post_types

  SVIE_ID = 369
  RVT_ID = 146
  KIRDEV_ID = 106

  def self.kirdev
    find KIRDEV_ID
  end

  def self.svie
    find SVIE_ID
  end

  def self.rvt
    find RVT_ID
  end

  def user_can_join?(current_user)
    !users_can_apply || current_user.membership_for(self)
  end

  def leader
    memberships.find { |membership| membership.leader? }
  end

  def post_types
    own_post_types + PostType.where(group: nil)
  end

  def current_delegated_count
    delegates = members.where(delegated: true)
     .select { |user| user.primary_membership.group == self && user.primary_membership.end.nil? }
    delegates.length
  end

  def can_delegate_more
    current_delegated_count < delegate_count
  end
end
