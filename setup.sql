-- TSI Updates Hub: run this once in Supabase > SQL Editor

create table if not exists public.tsi_updates (
  id       text primary key,
  title    text not null,
  tag      text not null default '',
  date     date not null,
  details  text not null,
  link     text not null default '',
  created  bigint not null,
  version  integer not null default 1,
  updated  bigint not null default 0,
  history  jsonb not null default '[]'::jsonb
);

alter table public.tsi_updates enable row level security;

-- Anyone with the link can read
drop policy if exists "read all" on public.tsi_updates;
create policy "read all" on public.tsi_updates
  for select to anon, authenticated using (true);

-- Only signed-in users can add, edit or delete
drop policy if exists "write signed in" on public.tsi_updates;
create policy "write signed in" on public.tsi_updates
  for all to authenticated using (true) with check (true);

-- Live updates
alter publication supabase_realtime add table public.tsi_updates;

-- Your existing update (carried over)
insert into public.tsi_updates (id, title, tag, date, details, link, created, version, updated, history)
values (
  'geo-dropdown-clarification',
  $t$Clarification: GEO pages dropdown under Areas We Serve$t$,
  $t$Client$t$,
  '2026-10-23',
  $t$The client confirmed the GEO pages must be built as a dropdown under Areas We Serve. Their site map lists each individual location as a subpage of Areas We Serve, so those locations belong in the navigation as a dropdown. Had the site map shown only “Areas We Serve” with no cities underneath, no subpages or dropdown would be needed. This corrects the earlier conclusion from Tuesday’s discussion (Oct 20) that a dropdown had not been requested.

Dev action: make Areas We Serve a parent item, list every site-map location as a child in the same order, link each to its GEO page, check desktop and mobile, and update any page already built without the dropdown.$t$,
  $t$https://claude.ai/artifact/EoCeFwGyECKBcuRYYW5cVz$t$,
  1792800000000, 1, 0, '[]'::jsonb
) on conflict (id) do nothing;
