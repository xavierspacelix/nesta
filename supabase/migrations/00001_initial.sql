-- Nesta: Initial Schema
-- All tables inferred from existing Dart models.
-- Every table has RLS enabled; policies grant access based on house membership.

-- 0. Extensions
create extension if not exists "pgcrypto";

-- 1. Houses
create table houses (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  invite_code text not null unique default encode(gen_random_bytes(6), 'hex'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 2. Profiles (extends auth.users)
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null,
  nickname text,
  email text not null,
  avatar_url text,
  house_id uuid references houses(id) on delete set null,
  role text not null default 'member' check (role in ('admin', 'member')),
  status text not null default 'active' check (status in ('active', 'inactive')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 3. Rooms
create table rooms (
  id uuid primary key default gen_random_uuid(),
  house_id uuid not null references houses(id) on delete cascade,
  name text not null,
  created_at timestamptz not null default now()
);

-- 4. Checklist items (belongs to a room)
create table checklist_items (
  id uuid primary key default gen_random_uuid(),
  room_id uuid not null references rooms(id) on delete cascade,
  title text not null,
  created_at timestamptz not null default now()
);

-- 5. Assignments (a task: user + room + date)
create table assignments (
  id uuid primary key default gen_random_uuid(),
  house_id uuid not null references houses(id) on delete cascade,
  room_id uuid not null references rooms(id) on delete cascade,
  assigned_to uuid not null references profiles(id) on delete cascade,
  assigned_date date not null,
  status text not null default 'pending' check (status in ('pending', 'in_progress', 'completed', 'missed')),
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  unique (room_id, assigned_to, assigned_date)
);

-- 6. Per-checklist-item progress for an assignment
create table assignment_checklist_progress (
  id uuid primary key default gen_random_uuid(),
  assignment_id uuid not null references assignments(id) on delete cascade,
  checklist_item_id uuid not null references checklist_items(id) on delete cascade,
  is_completed boolean not null default false,
  updated_by uuid references profiles(id),
  updated_at timestamptz default now(),
  unique (assignment_id, checklist_item_id)
);

-- 7. Task evidence photos
create table task_evidence (
  id uuid primary key default gen_random_uuid(),
  assignment_id uuid not null references assignments(id) on delete cascade,
  photo_url text not null,
  type text not null check (type in ('before', 'after')),
  uploaded_at timestamptz not null default now()
);

-- 8. Fines
create table fines (
  id uuid primary key default gen_random_uuid(),
  house_id uuid not null references houses(id) on delete cascade,
  member_id uuid not null references profiles(id) on delete cascade,
  reason text not null,
  amount integer not null check (amount > 0),
  status text not null default 'unpaid' check (status in ('unpaid', 'paid')),
  paid_at timestamptz,
  created_at timestamptz not null default now()
);

-- 9. Swap requests
create table swap_requests (
  id uuid primary key default gen_random_uuid(),
  house_id uuid not null references houses(id) on delete cascade,
  requester_id uuid not null references profiles(id) on delete cascade,
  target_id uuid not null references profiles(id) on delete cascade,
  assignment_id uuid not null references assignments(id) on delete cascade,
  schedule_date date not null,
  reason text not null,
  status text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  created_at timestamptz not null default now()
);

-- 10. Activity feed
create table activity_feed (
  id uuid primary key default gen_random_uuid(),
  house_id uuid not null references houses(id) on delete cascade,
  user_id uuid not null references profiles(id) on delete cascade,
  description text not null,
  category text not null check (category in ('chore', 'photo', 'swap', 'fine')),
  created_at timestamptz not null default now()
);

-- 11. Rent records
create table rent_records (
  id uuid primary key default gen_random_uuid(),
  house_id uuid not null references houses(id) on delete cascade,
  year integer not null,
  month integer not null check (month between 1 and 12),
  total_rent integer not null check (total_rent >= 0),
  total_wifi integer not null check (total_wifi >= 0),
  is_paid boolean not null default false,
  paid_at timestamptz,
  bank_name text,
  bank_account_number text,
  unique (house_id, year, month),
  created_at timestamptz not null default now()
);

-- 12. Member payments (per-member contribution to a rent record)
create table member_payments (
  id uuid primary key default gen_random_uuid(),
  rent_record_id uuid not null references rent_records(id) on delete cascade,
  member_id uuid not null references profiles(id) on delete cascade,
  is_paid boolean not null default false,
  proof_photo text,
  unique (rent_record_id, member_id)
);

-- 13. Electricity purchases
create table electricity_purchases (
  id uuid primary key default gen_random_uuid(),
  house_id uuid not null references houses(id) on delete cascade,
  amount integer not null check (amount > 0),
  purchased_by uuid not null references profiles(id) on delete cascade,
  proof_photo text,
  purchased_at timestamptz not null default now()
);

-- 14. Water purchases
create table water_purchases (
  id uuid primary key default gen_random_uuid(),
  house_id uuid not null references houses(id) on delete cascade,
  buyer_name text not null,
  purchased_at timestamptz not null default now()
);

-- Indexes
create index idx_profiles_house_id on profiles(house_id);
create index idx_rooms_house_id on rooms(house_id);
create index idx_checklist_items_room_id on checklist_items(room_id);
create index idx_assignments_house_id on assignments(house_id);
create index idx_assignments_assigned_to on assignments(assigned_to);
create index idx_assignments_assigned_date on assignments(assigned_date);
create index idx_fines_house_id on fines(house_id);
create index idx_swap_requests_house_id on swap_requests(house_id);
create index idx_activity_feed_house_id on activity_feed(house_id);
create index idx_activity_feed_created_at on activity_feed(created_at desc);
create index idx_rent_records_house_id on rent_records(house_id);
create index idx_electricity_purchases_house_id on electricity_purchases(house_id);
create index idx_water_purchases_house_id on water_purchases(house_id);

-- Row Level Security
alter table houses enable row level security;
alter table profiles enable row level security;
alter table rooms enable row level security;
alter table checklist_items enable row level security;
alter table assignments enable row level security;
alter table assignment_checklist_progress enable row level security;
alter table task_evidence enable row level security;
alter table fines enable row level security;
alter table swap_requests enable row level security;
alter table activity_feed enable row level security;
alter table rent_records enable row level security;
alter table member_payments enable row level security;
alter table electricity_purchases enable row level security;
alter table water_purchases enable row level security;

-- Helper: check if a user belongs to a house
create or replace function public.is_house_member(house_id uuid)
returns boolean
language sql
stable
security definer
as $$
  select exists (
    select 1 from profiles
    where id = auth.uid()
      and profiles.house_id = is_house_member.house_id
  );
$$;

-- Create a house and set creator as admin (bypasses circular RLS dependency)
create or replace function public.create_house(house_name text)
returns json
language plpgsql
security definer
set search_path = public
as $$
declare
  new_house houses;
begin
  insert into houses (name) values (house_name)
  returning * into new_house;

  update profiles
  set house_id = new_house.id, role = 'admin'
  where id = auth.uid();

  return row_to_json(new_house);
end;
$$;

-- Look up a house by invite code (bypasses member-only SELECT policy)
create or replace function public.get_house_by_invite(code text)
returns json
language plpgsql
security definer
set search_path = public
as $$
declare
  found_house houses;
begin
  select * into found_house from houses where invite_code = code;
  return row_to_json(found_house);
end;
$$;

-- RLS Policies

-- Houses: any authenticated user can create; members can read/update
create policy "Authenticated users can create houses"
  on houses for insert
  with check (auth.role() = 'authenticated');

create policy "Members can read their house"
  on houses for select
  using (is_house_member(id));

create policy "Members can update their house"
  on houses for update
  using (is_house_member(id))
  with check (is_house_member(id));

-- Profiles: users can read profiles in their house; update own profile
create policy "Users can read house member profiles"
  on profiles for select
  using (
    house_id is not null
    and is_house_member(house_id)
  );

create policy "Users can update own profile"
  on profiles for update
  using (id = auth.uid())
  with check (id = auth.uid());

create policy "Users can insert own profile"
  on profiles for insert
  with check (id = auth.uid());

-- Rooms: house members can CRUD
create policy "House members can read rooms"
  on rooms for select
  using (is_house_member(house_id));

create policy "House members can insert rooms"
  on rooms for insert
  with check (is_house_member(house_id));

create policy "House members can update rooms"
  on rooms for update
  using (is_house_member(house_id));

create policy "House members can delete rooms"
  on rooms for delete
  using (is_house_member(house_id));

-- Checklist items: through room ownership
create policy "House members can read checklist items"
  on checklist_items for select
  using (
    exists (
      select 1 from rooms
      where rooms.id = checklist_items.room_id
        and is_house_member(rooms.house_id)
    )
  );

create policy "House members can insert checklist items"
  on checklist_items for insert
  with check (
    exists (
      select 1 from rooms
      where rooms.id = checklist_items.room_id
        and is_house_member(rooms.house_id)
    )
  );

create policy "House members can update checklist items"
  on checklist_items for update
  using (
    exists (
      select 1 from rooms
      where rooms.id = checklist_items.room_id
        and is_house_member(rooms.house_id)
    )
  );

create policy "House members can delete checklist items"
  on checklist_items for delete
  using (
    exists (
      select 1 from rooms
      where rooms.id = checklist_items.room_id
        and is_house_member(rooms.house_id)
    )
  );

-- Assignments: house members can read/insert; assigned user can update
create policy "House members can read assignments"
  on assignments for select
  using (is_house_member(house_id));

create policy "House members can insert assignments"
  on assignments for insert
  with check (is_house_member(house_id));

create policy "Assigned user or house members can update assignments"
  on assignments for update
  using (assigned_to = auth.uid() or is_house_member(house_id))
  with check (assigned_to = auth.uid() or is_house_member(house_id));

-- Assignment checklist progress: through assignment
create policy "House members can read checklist progress"
  on assignment_checklist_progress for select
  using (
    exists (
      select 1 from assignments
      where assignments.id = assignment_checklist_progress.assignment_id
        and is_house_member(assignments.house_id)
    )
  );

create policy "House members can insert checklist progress"
  on assignment_checklist_progress for insert
  with check (
    exists (
      select 1 from assignments
      where assignments.id = assignment_checklist_progress.assignment_id
        and is_house_member(assignments.house_id)
    )
  );

create policy "Assigned user can update checklist progress"
  on assignment_checklist_progress for update
  using (
    exists (
      select 1 from assignments
      where assignments.id = assignment_checklist_progress.assignment_id
        and assignments.assigned_to = auth.uid()
    )
  );

-- Task evidence: through assignment
create policy "House members can read task evidence"
  on task_evidence for select
  using (
    exists (
      select 1 from assignments
      where assignments.id = task_evidence.assignment_id
        and is_house_member(assignments.house_id)
    )
  );

create policy "Assigned user can insert task evidence"
  on task_evidence for insert
  with check (
    exists (
      select 1 from assignments
      where assignments.id = task_evidence.assignment_id
        and assignments.assigned_to = auth.uid()
    )
  );

-- Fines
create policy "House members can read fines"
  on fines for select
  using (is_house_member(house_id));

create policy "Admin can insert fines"
  on fines for insert
  with check (
    is_house_member(house_id)
    and exists (
      select 1 from profiles
      where id = auth.uid()
        and role = 'admin'
    )
  );

create policy "Fined member can mark as paid"
  on fines for update
  using (member_id = auth.uid())
  with check (member_id = auth.uid());

-- Swap requests
create policy "House members can read swap requests"
  on swap_requests for select
  using (is_house_member(house_id));

create policy "House members can create swap requests"
  on swap_requests for insert
  with check (is_house_member(house_id));

create policy "Target can approve or reject swap"
  on swap_requests for update
  using (target_id = auth.uid())
  with check (target_id = auth.uid());

-- Activity feed: read-only for house members
create policy "House members can read activity feed"
  on activity_feed for select
  using (is_house_member(house_id));

create policy "House members can insert activity feed"
  on activity_feed for insert
  with check (is_house_member(house_id));

-- Rent records
create policy "House members can read rent records"
  on rent_records for select
  using (is_house_member(house_id));

create policy "House members can insert rent records"
  on rent_records for insert
  with check (is_house_member(house_id));

create policy "House members can update rent records"
  on rent_records for update
  using (is_house_member(house_id));

-- Member payments
create policy "House members can read member payments"
  on member_payments for select
  using (
    exists (
      select 1 from rent_records
      where rent_records.id = member_payments.rent_record_id
        and is_house_member(rent_records.house_id)
    )
  );

create policy "Members can update their own payment"
  on member_payments for update
  using (member_id = auth.uid())
  with check (member_id = auth.uid());

create policy "House members can insert member payments"
  on member_payments for insert
  with check (
    exists (
      select 1 from rent_records
      where rent_records.id = member_payments.rent_record_id
        and is_house_member(rent_records.house_id)
    )
  );

-- Electricity purchases
create policy "House members can read electricity purchases"
  on electricity_purchases for select
  using (is_house_member(house_id));

create policy "House members can insert electricity purchases"
  on electricity_purchases for insert
  with check (is_house_member(house_id));

-- Water purchases
create policy "House members can read water purchases"
  on water_purchases for select
  using (is_house_member(house_id));

create policy "House members can insert water purchases"
  on water_purchases for insert
  with check (is_house_member(house_id));

-- Auto-create profile on user signup
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, name, email, avatar_url)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', new.email),
    new.email,
    new.raw_user_meta_data ->> 'avatar_url'
  );
  return new;
end;
$$;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row
  execute function public.handle_new_user();

-- Generate fines for past-due pending assignments
-- Formula: (100 - progress%) × 500, max Rp50.000, min Rp0
create or replace function public.generate_fines()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_assignment record;
  v_total_items int;
  v_completed_items int;
  v_completion_pct numeric;
  v_fine_amount int;
begin
  for v_assignment in
    select
      a.id, a.house_id, a.assigned_to, a.assigned_date,
      r.name as room_name
    from assignments a
    join rooms r on r.id = a.room_id
    where a.assigned_date < current_date
      and a.status = 'pending'
      and not exists (
        select 1 from fines f
        where f.member_id = a.assigned_to
          and f.created_at::date = a.assigned_date
      )
  loop
    select
      count(*),
      count(*) filter (where acp.is_completed = true)
    into v_total_items, v_completed_items
    from assignment_checklist_progress acp
    where acp.assignment_id = v_assignment.id;

    if v_total_items > 0 then
      v_completion_pct := (v_completed_items::numeric / v_total_items) * 100;
    else
      v_completion_pct := 0;
    end if;

    v_fine_amount := greatest(0, least(50000, ((100 - v_completion_pct) * 500)::int));

    if v_fine_amount > 0 then
      insert into fines (house_id, member_id, reason, amount, status)
      values (
        v_assignment.house_id,
        v_assignment.assigned_to,
        'Piket ' || v_assignment.room_name || ' (' || v_assignment.assigned_date || ')',
        v_fine_amount,
        'unpaid'
      );
    end if;

    update assignments set status = 'missed'
    where id = v_assignment.id;
  end loop;
end;
$$;
