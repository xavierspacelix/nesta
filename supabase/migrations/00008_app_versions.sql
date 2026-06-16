create table app_versions (
  id uuid primary key default gen_random_uuid(),
  version text not null,
  build_number integer not null,
  force_update boolean not null default false,
  changelog text not null default '',
  apk_url text not null,
  created_at timestamptz not null default now()
);

create index idx_app_versions_build on app_versions(build_number desc);

alter table app_versions enable row level security;

create policy "Anyone can read app versions"
  on app_versions for select
  using (true);
