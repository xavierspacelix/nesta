alter table activity_feed
  add column target_user_id uuid references profiles(id) on delete cascade;

create index idx_activity_feed_target_user on activity_feed(target_user_id);
