-- Add verification tracking to water_purchases
alter table water_purchases
  add column if not exists proof_photo text,
  add column if not exists is_verified boolean not null default false,
  add column if not exists verified_by uuid references profiles(id),
  add column if not exists verified_at timestamptz;

-- Add admin-only update policy
create policy "Admin can verify water purchase"
  on water_purchases for update
  using (
    exists (
      select 1 from profiles
      where id = auth.uid()
        and role = 'admin'
    )
  )
  with check (
    exists (
      select 1 from profiles
      where id = auth.uid()
        and role = 'admin'
    )
  );
