-- Add due_date to rent_records (day of month, 1-31)
alter table rent_records
  add column if not exists due_date integer not null default 1 check (due_date between 1 and 31);
