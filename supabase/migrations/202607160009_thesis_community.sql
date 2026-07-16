create table if not exists public.thesis_content (
  id text primary key default 'primary' check (id = 'primary'),
  section_headline text not null,
  title text not null,
  subtitle text not null,
  status text not null default 'Completed',
  institution text not null,
  discipline text not null,
  supervisor text not null,
  year integer not null check (year between 1900 and 2200),
  related_url text,
  visible boolean not null default true,
  updated_at timestamptz not null default now()
);

create table if not exists public.community_entries (
  id uuid primary key default gen_random_uuid(),
  organization text not null,
  role_period text not null default '',
  description text not null default '',
  url text,
  sort_order integer not null default 0,
  visible boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists thesis_content_set_updated_at on public.thesis_content;
create trigger thesis_content_set_updated_at before update on public.thesis_content for each row execute function public.set_updated_at();
drop trigger if exists community_entries_set_updated_at on public.community_entries;
create trigger community_entries_set_updated_at before update on public.community_entries for each row execute function public.set_updated_at();

alter table public.thesis_content enable row level security;
alter table public.community_entries enable row level security;
create policy "visible thesis is public" on public.thesis_content for select using (visible or public.is_cms_admin());
create policy "admins insert thesis" on public.thesis_content for insert with check (public.is_cms_admin());
create policy "admins update thesis" on public.thesis_content for update using (public.is_cms_admin()) with check (public.is_cms_admin());
create policy "visible community entries are public" on public.community_entries for select using (visible or public.is_cms_admin());
create policy "admins create community entries" on public.community_entries for insert with check (public.is_cms_admin());
create policy "admins update community entries" on public.community_entries for update using (public.is_cms_admin()) with check (public.is_cms_admin());
create policy "admins delete community entries" on public.community_entries for delete using (public.is_cms_admin());

insert into public.thesis_content (id,section_headline,title,subtitle,status,institution,discipline,supervisor,year,related_url) values
('primary','Research built to be understood.','FetalCareXAI','A robust machine-learning framework for fetal health monitoring with explainable AI.','Completed','East West University','Computer Science & Engineering','Dr. Md. Atiqur Rahman',2025,'/projects')
on conflict (id) do nothing;

insert into public.community_entries (organization,role_period,description,sort_order) values
('Bangladesh Physics Olympiad','BOGRA REGION · 2024–2025','Supported regional learning and science-focused community activities.',1),
('Volunteer for Bangladesh','VOLUNTEER','Contributed to collaborative community initiatives beyond software.',2)
on conflict do nothing;
