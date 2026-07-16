create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  title text not null unique,
  category text not null check (category in ('Research','Web App','Systems')),
  status text not null check (status in ('Complete','In Progress')),
  description text not null default '',
  tags text[] not null default '{}',
  live_url text,
  github_url text,
  source_visibility text not null default 'Unconfirmed' check (source_visibility in ('Public','Private','Unconfirmed')),
  featured boolean not null default false,
  sort_order integer not null default 0,
  visible boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
drop trigger if exists projects_set_updated_at on public.projects;
create trigger projects_set_updated_at before update on public.projects for each row execute function public.set_updated_at();
alter table public.projects enable row level security;
create policy "visible projects are public" on public.projects for select using (visible or public.is_cms_admin());
create policy "admins create projects" on public.projects for insert with check (public.is_cms_admin());
create policy "admins update projects" on public.projects for update using (public.is_cms_admin()) with check (public.is_cms_admin());
create policy "admins delete projects" on public.projects for delete using (public.is_cms_admin());

insert into public.projects (title,category,status,description,tags,github_url,source_visibility,featured,sort_order) values
('FetalCareXAI','Research','Complete','An explainable fetal-health classification application using a LightGBM model and LIME to turn predictions into interpretable evidence through an accessible Flask-based interface.',array['LightGBM','LIME','Flask'],'https://github.com/EganStark/FetalCareXAI_V1.00','Public',true,1),
('REMP','Research','Complete','A Swin Transformer-based rare medicinal plant classifier achieving 98.46% accuracy. The work was developed into a published research paper.',array['Swin Transformer','Computer Vision','Python'],null,'Unconfirmed',false,2),
('Explainable CNN for Nitrogen Deficiency','Research','Complete','An explainable CNN pipeline for detecting nitrogen deficiency in crops from leaf imagery. The associated multi-crop research is published through IEEE ICCIT 2025.',array['CNN','Grad-CAM','Agriculture AI'],null,'Unconfirmed',false,3),
('Baitur Rahman Jame Mosjid Admin Panel','Web App','Complete','A secure Bengali administration system for managing mosque members, donations, expenses, bank transactions, role-based access, and printable financial reports.',array['Node.js','PostgreSQL','Bengali UI'],'https://github.com/EganStark/Baitur-Rahman-Jame-Mosjid-Updated','Public',false,4),
('Emergency Ambulance Service','Web App','Complete','A database-backed emergency ambulance service with user accounts, driver registration, booking and ongoing-service workflows, search, profiles, and administrative management.',array['PHP','MySQL','Bootstrap'],'https://github.com/EganStark/Emargency-Ambulance-Sevice-EAS-','Public',false,5),
('FIFA World Cup 2026 Schedule App','Web App','Complete','A standalone progressive web app with timezone-aware fixtures, venue tabs, favourites, and a knockout bracket for following the tournament.',array['PWA','JavaScript','HTML'],null,'Unconfirmed',false,6),
('2D Solar Energy System Simulation','Systems','Complete','A two-dimensional solar energy system simulation built close to the graphics layer using C++ and OpenGL.',array['C++','OpenGL','Simulation'],null,'Unconfirmed',false,7),
('Rhythm Wellbeing','Web App','In Progress','A private personal wellbeing and time-tracking product for understanding routines and building healthier patterns over time.',array['React','Supabase','Product Design'],null,'Private',false,8)
on conflict (title) do nothing;
