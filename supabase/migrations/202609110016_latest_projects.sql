begin;

delete from public.projects
where title in (
  'FIFA World Cup 2026 Schedule App',
  'Baitur Rahman Jame Mosjid Admin Panel'
);

insert into public.projects (
  title, category, status, description, tags, live_url, github_url,
  source_visibility, featured, sort_order, visible
) values
(
  'Mosque Management System',
  'Web App',
  'Complete',
  'A bilingual full-stack platform for mosque and community operations, combining a public information site with secure administration for members, programs, donations, finance, permissions, and audit-ready records.',
  array['React','TypeScript','Node.js','PostgreSQL'],
  'https://mosque-management-system-bd.vercel.app/',
  'https://github.com/EganStark/mosque_management_system_bd',
  'Public', false, 6, true
),
(
  'Pagewise',
  'Web App',
  'Complete',
  'A private, installable reading companion that combines detailed reading history with physical-library inventory, multilingual metadata discovery, lending, personal statistics, and optional grounded AI review.',
  array['React','TypeScript','Supabase','PWA'],
  'https://pagewise-rose.vercel.app/',
  'https://github.com/EganStark/pagewise',
  'Public', false, 7, true
),
(
  'BDIX Local Stremio Addon',
  'Systems',
  'Complete',
  'A local-first Python system that indexes authorized BDIX media directories, resolves titles through TMDB and IMDb metadata, and exposes matching direct streams through the standard Stremio addon protocol.',
  array['Python','SQLite','Stremio','TMDB'],
  null,
  'https://github.com/EganStark/bdix-stremio-dhakaflix',
  'Public', false, 9, true
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

update public.projects
set sort_order = case title
  when 'FetalCareXAI' then 1
  when 'Rhythm Wellbeing' then 2
  when 'REMP' then 3
  when 'Sabit Al Alfi Portfolio & CMS' then 4
  when 'Explainable CNN for Nitrogen Deficiency' then 5
  when 'Mosque Management System' then 6
  when 'Pagewise' then 7
  when 'Emergency Ambulance Service' then 8
  when 'BDIX Local Stremio Addon' then 9
  when '2D Solar Energy System Simulation' then 10
  else sort_order
end;

commit;
