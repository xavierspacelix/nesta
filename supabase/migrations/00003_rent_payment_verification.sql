-- Add verification tracking to member_payments
alter table member_payments
  add column if not exists verified_by uuid references profiles(id),
  add column if not exists verified_at timestamptz;

-- Drop old update policy and add role-aware policies
drop policy if exists "Members can update their own payment" on member_payments;

create policy "Member can upload proof"
  on member_payments for update
  using (member_id = auth.uid())
  with check (member_id = auth.uid());

create policy "Admin can verify payment"
  on member_payments for update
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
