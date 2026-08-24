# Avril Tracker

A tiny shared web form for logging baby Avril's naps, poops, and feeds. Single
static page, no build step, backed by Supabase. Same pattern as
tantrumtracker: plain HTML/JS + `@supabase/supabase-js` via CDN, deployed on
GitHub Pages.

## Setup

1. Create a Supabase project.
2. Open the SQL editor and run `schema.sql`.
3. In `index.html`, fill in `SUPABASE_URL` and `SUPABASE_ANON_KEY` near the
   top of the `<script>` block (Project Settings → API in the Supabase
   dashboard).
4. Push to GitHub and enable Pages (Settings → Pages → deploy from branch,
   root of `main`).
5. Share the Pages URL.

There's no login screen — privacy relies on the URL (and the embedded anon
key) being unguessable, not on auth. GitHub Pages requires a public repo
unless you're on a paid GitHub plan, which is a privacy tradeoff worth
knowing about before sharing the link.

## How the nap schedule works

Enter this morning's wake time and the app estimates naps using a 2-hour
awake window: awake 2h → nap (1.5h, 1.5h, then 30min) → awake 2h → next nap.
A 4th nap (30min) can be toggled on for days that need it. Bedtime is
estimated as 2h45m after the last nap ends. These are estimates to plan
around, not a schedule that's enforced — actual nap/poop/feed times are
logged separately as they happen.

## Data model

- `sleep_log` — one row per date (upserted): wake time, computed nap
  start/end times, bedtime estimate.
- `poop_log` — append-only, individually deletable time entries.
- `drink_log` — append-only, individually deletable entries; each is either
  a bottle (`volume_ml`) or a breastfeed (`breastfeed_minutes` +
  optional `breastfeed_amount` note).
