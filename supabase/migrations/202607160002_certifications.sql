create table if not exists public.certifications (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 2 and 160),
  provider text not null check (char_length(provider) between 2 and 120),
  status text not null default 'in_progress' check (status in ('completed', 'in_progress')),
  description text not null default '' check (char_length(description) <= 500),
  credential_url text,
  issued_at date,
  sort_order integer not null default 0,
  visible boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists certifications_set_updated_at on public.certifications;
create trigger certifications_set_updated_at before update on public.certifications
for each row execute function public.set_updated_at();

alter table public.certifications enable row level security;

create policy "visible certifications are public" on public.certifications
for select using (visible or public.is_cms_admin());

create policy "admins can create certifications" on public.certifications
for insert with check (public.is_cms_admin());

create policy "admins can update certifications" on public.certifications
for update using (public.is_cms_admin()) with check (public.is_cms_admin());

create policy "admins can delete certifications" on public.certifications
for delete using (public.is_cms_admin());

insert into public.certifications (title, provider, status, description, sort_order)
select 'Introduction to Python', 'DataCamp', 'completed', 'Completed foundational training in Python syntax, data types, control flow, and practical programming.', 1
where not exists (select 1 from public.certifications where title = 'Introduction to Python');

insert into public.certifications (title, provider, status, description, sort_order)
select 'Associate Data Scientist in Python', 'DataCamp', 'in_progress', 'An active learning track covering data manipulation, analysis, statistics, and machine-learning foundations.', 2
where not exists (select 1 from public.certifications where title = 'Associate Data Scientist in Python');
