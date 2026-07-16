create table if not exists public.profile_content (
  id text primary key default 'primary' check (id = 'primary'),
  display_name text not null,
  role_line text not null,
  hero_headline text not null,
  hero_intro text not null,
  location text not null,
  focus_label text not null,
  work_mode text not null,
  availability_enabled boolean not null default true,
  availability_title text not null,
  availability_detail text not null,
  home_about_headline text not null,
  home_about_description text not null,
  about_headline text not null,
  about_intro text not null,
  about_principles_headline text not null,
  about_focus text not null,
  about_detail text not null,
  portrait_url text,
  portrait_alt text not null,
  cv_url text not null default '/Sabit-Al-Alfi-CV.pdf',
  updated_at timestamptz not null default now()
);

drop trigger if exists profile_content_set_updated_at on public.profile_content;
create trigger profile_content_set_updated_at before update on public.profile_content
for each row execute function public.set_updated_at();

alter table public.profile_content enable row level security;
create policy "profile content is public" on public.profile_content for select using (true);
create policy "admins update profile content" on public.profile_content for update using (public.is_cms_admin()) with check (public.is_cms_admin());
create policy "admins insert profile content" on public.profile_content for insert with check (public.is_cms_admin());

insert into public.profile_content (
  id, display_name, role_line, hero_headline, hero_intro, location, focus_label, work_mode,
  availability_enabled, availability_title, availability_detail,
  home_about_headline, home_about_description, about_headline, about_intro,
  about_principles_headline, about_focus, about_detail, portrait_alt, cv_url
) values (
  'primary', 'Sabit Al Alfi', 'ENGINEER · RESEARCHER · BUILDER',
  'I make complex systems easier to understand.',
  'I’m Sabit Al Alfi, a computer science graduate building explainable AI systems and practical software—from research prototypes to products people can use.',
  'Dhaka, Bangladesh', 'Explainable AI', 'Research + Shipping', true,
  'Available for opportunities', 'Seeking Data Science, Machine Learning, and AI Engineer roles.',
  'Research depth. Engineering range.',
  'My work sits between understanding and building. I study why models make decisions, then carry that same first-principles mindset into databases, interfaces, graphics, and systems. The goal is not technology for its own sake—it is software that earns trust by being clear, useful, and well made.',
  'Curiosity across the stack.',
  'I’m a Computer Science & Engineering graduate from East West University, specializing in Data Science and explainable AI.',
  'I like understanding systems from first principles.',
  'My focus is building models that are not just accurate, but interpretable—alongside full-stack and systems-level engineering.',
  'I care about how things actually work, whether that is a CNN’s attention map, a database schema, or a Linux boot process. I’m currently looking for Data Science, ML, and AI Engineer roles, with a longer-term goal of graduate research abroad.',
  'Graduation portrait of Sabit Al Alfi', '/Sabit-Al-Alfi-CV.pdf'
) on conflict (id) do nothing;
