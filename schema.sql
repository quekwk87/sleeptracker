-- Avril Tracker schema
-- Run this in the Supabase SQL editor for a fresh project.

create extension if not exists pgcrypto;

-- One row per date, upserted as the day's nap schedule is filled in.
create table if not exists sleep_log (
  date date primary key,
  wake_time time,
  nap4_enabled boolean not null default false,
  nap1_start time,
  nap1_end time,
  nap2_start time,
  nap2_end time,
  nap3_start time,
  nap3_end time,
  nap4_start time,
  nap4_end time,
  bedtime_estimate time,
  updated_at timestamptz not null default now()
);

-- Append-only, individually deletable entries.
create table if not exists poop_log (
  id uuid primary key default gen_random_uuid(),
  date date not null,
  time time not null,
  created_at timestamptz not null default now()
);

create table if not exists drink_log (
  id uuid primary key default gen_random_uuid(),
  date date not null,
  time time not null,
  type text not null check (type in ('volume', 'breastfeed')),
  volume_ml integer,
  breastfeed_minutes integer,
  breastfeed_amount text,
  created_at timestamptz not null default now()
);

create index if not exists poop_log_date_idx on poop_log (date);
create index if not exists drink_log_date_idx on drink_log (date);

alter table sleep_log enable row level security;
alter table poop_log enable row level security;
alter table drink_log enable row level security;

-- No login screen: privacy relies on the app URL + Supabase keys being
-- unguessable, matching the tantrumtracker setup. Anyone with the anon
-- key can read/write everything.
create policy "anon full access sleep_log" on sleep_log for all using (true) with check (true);
create policy "anon full access poop_log" on poop_log for all using (true) with check (true);
create policy "anon full access drink_log" on drink_log for all using (true) with check (true);

grant all on sleep_log, poop_log, drink_log to anon, authenticated;
