update public.projects
set
  status = 'Complete',
  live_url = 'https://pagewise-rose.vercel.app/',
  github_url = 'https://github.com/EganStark/pagewise',
  source_visibility = 'Public',
  visible = true
where title = 'Pagewise';
