create table if not exists public.experience_entries (
  id uuid primary key default gen_random_uuid(), title text not null, organization text not null,
  period text not null default '', location text not null default '', description text not null default '',
  url text, sort_order integer not null default 0, visible boolean not null default true,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.achievements (
  id uuid primary key default gen_random_uuid(), kind text not null check(kind in ('Award','Hackathon','Presentation','Competition')),
  title text not null, organization text not null default '', event_date date, description text not null default '', url text,
  sort_order integer not null default 0, visible boolean not null default true,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.page_sections (
  section_key text primary key, page text not null check(page in ('home','about')),
  label text not null, visible boolean not null default true, sort_order integer not null default 0,
  updated_at timestamptz not null default now()
);
create table if not exists public.post_revisions (
  id uuid primary key default gen_random_uuid(), post_id uuid not null references public.posts(id) on delete cascade,
  snapshot jsonb not null, created_at timestamptz not null default now(), created_by uuid references auth.users(id)
);

do $$ declare t text; begin foreach t in array array['experience_entries','achievements','page_sections'] loop
  execute format('drop trigger if exists %I_set_updated_at on public.%I',t,t);
  execute format('create trigger %I_set_updated_at before update on public.%I for each row execute function public.set_updated_at()',t,t);
end loop; end $$;

create or replace function public.capture_post_revision() returns trigger language plpgsql security definer set search_path=public as $$
begin
  insert into public.post_revisions(post_id,snapshot,created_by) values(old.id,to_jsonb(old),auth.uid());
  return new;
end $$;
drop trigger if exists posts_capture_revision on public.posts;
create trigger posts_capture_revision before update on public.posts for each row execute function public.capture_post_revision();

alter table public.experience_entries enable row level security; alter table public.achievements enable row level security;
alter table public.page_sections enable row level security; alter table public.post_revisions enable row level security;
create policy "visible experience is public" on public.experience_entries for select using(visible or public.is_cms_admin());
create policy "admins manage experience insert" on public.experience_entries for insert with check(public.is_cms_admin());
create policy "admins manage experience update" on public.experience_entries for update using(public.is_cms_admin()) with check(public.is_cms_admin());
create policy "admins manage experience delete" on public.experience_entries for delete using(public.is_cms_admin());
create policy "visible achievements are public" on public.achievements for select using(visible or public.is_cms_admin());
create policy "admins manage achievements insert" on public.achievements for insert with check(public.is_cms_admin());
create policy "admins manage achievements update" on public.achievements for update using(public.is_cms_admin()) with check(public.is_cms_admin());
create policy "admins manage achievements delete" on public.achievements for delete using(public.is_cms_admin());
create policy "section settings are public" on public.page_sections for select using(true);
create policy "admins update sections" on public.page_sections for update using(public.is_cms_admin()) with check(public.is_cms_admin());
create policy "admins insert sections" on public.page_sections for insert with check(public.is_cms_admin());
create policy "admins view revisions" on public.post_revisions for select using(public.is_cms_admin());
create policy "admins delete revisions" on public.post_revisions for delete using(public.is_cms_admin());

insert into public.page_sections(section_key,page,label,sort_order) values
('home_about','home','About',1),('home_projects','home','Selected work',2),('home_skills','home','Capabilities',3),('home_research','home','Research',4),('home_contact','home','Contact',5),
('about_principles','about','Principles',1),('about_skills','about','Capabilities',2),('about_thesis','about','Thesis',3),('about_education','about','Education',4),('about_coursework','about','Coursework',5),('about_certifications','about','Certifications',6),('about_experience','about','Experience',7),('about_achievements','about','Awards & activities',8),('about_community','about','Community',9)
on conflict(section_key) do nothing;

grant select on public.experience_entries,public.achievements,public.page_sections to anon,authenticated;
grant insert,update,delete on public.experience_entries,public.achievements to authenticated;
grant insert,update on public.page_sections to authenticated;
grant select,delete on public.post_revisions to authenticated;
revoke insert,update,delete on public.experience_entries,public.achievements,public.page_sections,public.post_revisions from anon;
