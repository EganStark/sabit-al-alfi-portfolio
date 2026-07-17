insert into public.projects (
  title,
  category,
  status,
  description,
  tags,
  live_url,
  github_url,
  source_visibility,
  featured,
  sort_order,
  visible
) values (
  'Sabit Al Alfi Portfolio & CMS',
  'Web App',
  'Complete',
  'A research-led portfolio paired with a secure owner CMS for managing projects, publications, posts, profile content, media, and site settings without compromising the code-owned design system.',
  array['Astro','TypeScript','Supabase','Vercel'],
  'https://sabit-al-alfi-portfolio.vercel.app',
  'https://github.com/EganStark/sabit-al-alfi-portfolio',
  'Public',
  false,
  9,
  true
)
on conflict (title) do update set
  category = excluded.category,
  status = excluded.status,
  description = excluded.description,
  tags = excluded.tags,
  live_url = excluded.live_url,
  github_url = excluded.github_url,
  source_visibility = excluded.source_visibility,
  featured = excluded.featured,
  sort_order = excluded.sort_order,
  visible = excluded.visible;
