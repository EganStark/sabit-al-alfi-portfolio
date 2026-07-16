create table if not exists public.site_settings (
  id text primary key default 'primary' check (id = 'primary'),
  site_title text not null,
  default_description text not null,
  author_name text not null,
  footer_tagline text not null,
  og_image_url text not null default '/og-image.svg',
  site_url text,
  updated_at timestamptz not null default now()
);

drop trigger if exists site_settings_set_updated_at on public.site_settings;
create trigger site_settings_set_updated_at before update on public.site_settings for each row execute function public.set_updated_at();
alter table public.site_settings enable row level security;
create policy "site settings are public" on public.site_settings for select using (true);
create policy "admins insert site settings" on public.site_settings for insert with check (public.is_cms_admin());
create policy "admins update site settings" on public.site_settings for update using (public.is_cms_admin()) with check (public.is_cms_admin());

insert into public.site_settings (id,site_title,default_description,author_name,footer_tagline,og_image_url) values
('primary','Sabit Al Alfi — Engineer & XAI Researcher','Sabit Al Alfi builds explainable AI systems and practical software across research, web, and systems engineering.','Sabit Al Alfi','Built with clarity and care.','/og-image.svg')
on conflict (id) do nothing;
