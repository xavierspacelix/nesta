-- Add verification tracking to electricity_purchases
alter table electricity_purchases
  add column if not exists is_verified boolean not null default false,
  add column if not exists verified_by uuid references profiles(id),
  add column if not exists verified_at timestamptz;

-- Update RLS: add admin-only update policy
create policy "Admin can verify electricity purchase"
  on electricity_purchases for update
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
