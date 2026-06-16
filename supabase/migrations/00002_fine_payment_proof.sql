-- Add proof_photo and verification tracking columns to fines
alter table fines
  add column if not exists proof_photo text,
  add column if not exists paid_by uuid references profiles(id),
  add column if not exists verified_by uuid references profiles(id),
  add column if not exists verified_at timestamptz;

-- Update status check constraint to include pending_verification
alter table fines
  drop constraint if exists fines_status_check,
  add constraint fines_status_check
    check (status in ('unpaid', 'pending_verification', 'paid'));

-- Drop old update policy and replace with role-aware policies
drop policy if exists "Fined member can mark as paid" on fines;

create policy "Member can upload proof"
  on fines for update
  using (member_id = auth.uid())
  with check (
    member_id = auth.uid()
    and status = 'pending_verification'
    and proof_photo is not null
  );

create policy "Admin can verify payment"
  on fines for update
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
    and status = 'paid'
  );
