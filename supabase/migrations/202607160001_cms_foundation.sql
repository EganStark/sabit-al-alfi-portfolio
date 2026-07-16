create extension if not exists pgcrypto;

create table if not exists public.cms_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create or replace function public.is_cms_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.cms_admins where user_id = auth.uid()
  );
$$;

create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 3 and 160),
  slug text not null unique check (slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  excerpt text not null default '' check (char_length(excerpt) <= 320),
  body text not null default '',
  cover_url text,
  cover_alt text,
  tags text[] not null default '{}',
  status text not null default 'draft' check (status in ('draft', 'published', 'scheduled')),
  featured boolean not null default false,
  published_at timestamptz,
  author_id uuid not null default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists posts_set_updated_at on public.posts;
create trigger posts_set_updated_at before update on public.posts
for each row execute function public.set_updated_at();

alter table public.cms_admins enable row level security;
alter table public.posts enable row level security;

create policy "admins can view their membership" on public.cms_admins
for select using (user_id = auth.uid());

create policy "published posts are public" on public.posts
for select using (
  (status = 'published' and coalesce(published_at, now()) <= now())
  or public.is_cms_admin()
);

create policy "admins can create posts" on public.posts
for insert with check (public.is_cms_admin() and author_id = auth.uid());

create policy "admins can update posts" on public.posts
for update using (public.is_cms_admin()) with check (public.is_cms_admin());

create policy "admins can delete posts" on public.posts
for delete using (public.is_cms_admin());

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('cms-media', 'cms-media', true, 5242880, array['image/jpeg','image/png','image/webp','image/avif'])
on conflict (id) do nothing;

create policy "public can view cms media" on storage.objects
for select using (bucket_id = 'cms-media');

create policy "admins can upload cms media" on storage.objects
for insert with check (bucket_id = 'cms-media' and public.is_cms_admin());

create policy "admins can update cms media" on storage.objects
for update using (bucket_id = 'cms-media' and public.is_cms_admin());

create policy "admins can delete cms media" on storage.objects
for delete using (bucket_id = 'cms-media' and public.is_cms_admin());

-- After creating the owner in Supabase Authentication, run once:
-- insert into public.cms_admins (user_id) values ('YOUR_AUTH_USER_UUID');
