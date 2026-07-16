create table if not exists public.contact_content (
  id text primary key default 'primary' check (id = 'primary'),
  email text not null,
  page_headline text not null,
  page_intro text not null,
  online_headline text not null,
  online_intro text not null,
  form_button_label text not null,
  home_headline text not null,
  home_description text not null,
  updated_at timestamptz not null default now()
);

create table if not exists public.social_links (
  id uuid primary key default gen_random_uuid(),
  label text not null,
  display_value text not null,
  url text not null,
  icon text not null default 'external' check (icon in ('linkedin','github','gmail','document','external')),
  sort_order integer not null default 0,
  visible boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists contact_content_set_updated_at on public.contact_content;
create trigger contact_content_set_updated_at before update on public.contact_content for each row execute function public.set_updated_at();
drop trigger if exists social_links_set_updated_at on public.social_links;
create trigger social_links_set_updated_at before update on public.social_links for each row execute function public.set_updated_at();

alter table public.contact_content enable row level security;
alter table public.social_links enable row level security;
create policy "contact content is public" on public.contact_content for select using (true);
create policy "admins insert contact content" on public.contact_content for insert with check (public.is_cms_admin());
create policy "admins update contact content" on public.contact_content for update using (public.is_cms_admin()) with check (public.is_cms_admin());
create policy "visible social links are public" on public.social_links for select using (visible or public.is_cms_admin());
create policy "admins create social links" on public.social_links for insert with check (public.is_cms_admin());
create policy "admins update social links" on public.social_links for update using (public.is_cms_admin()) with check (public.is_cms_admin());
create policy "admins delete social links" on public.social_links for delete using (public.is_cms_admin());

insert into public.contact_content (id,email,page_headline,page_intro,online_headline,online_intro,form_button_label,home_headline,home_description) values
('primary','sabit.alfie@gmail.com','Let’s build something that matters.','Reach out about Data Science, ML and AI engineering roles, research, or thoughtful software collaborations.','Find me online.','For professional opportunities, research conversations, and collaborations.','Prepare email','Let’s build something that matters.','I’m currently looking for roles and collaborations in data science, machine learning, and AI engineering.')
on conflict (id) do nothing;

insert into public.social_links (label,display_value,url,icon,sort_order) values
('LinkedIn','/in/sabitalfi','https://www.linkedin.com/in/sabitalfi/','linkedin',1),
('GitHub','@EganStark','https://github.com/EganStark','github',2)
on conflict do nothing;
