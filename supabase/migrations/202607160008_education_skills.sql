create table if not exists public.education_records (
  id uuid primary key default gen_random_uuid(),
  period text not null,
  title text not null,
  institution text not null,
  detail text not null default '',
  result text not null default '',
  sort_order integer not null default 0,
  visible boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.skill_groups (
  id uuid primary key default gen_random_uuid(),
  title text not null unique,
  skills text[] not null default '{}',
  sort_order integer not null default 0,
  visible boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.coursework (
  id uuid primary key default gen_random_uuid(),
  title text not null unique,
  sort_order integer not null default 0,
  visible boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists education_records_set_updated_at on public.education_records;
create trigger education_records_set_updated_at before update on public.education_records for each row execute function public.set_updated_at();
drop trigger if exists skill_groups_set_updated_at on public.skill_groups;
create trigger skill_groups_set_updated_at before update on public.skill_groups for each row execute function public.set_updated_at();
drop trigger if exists coursework_set_updated_at on public.coursework;
create trigger coursework_set_updated_at before update on public.coursework for each row execute function public.set_updated_at();

alter table public.education_records enable row level security;
alter table public.skill_groups enable row level security;
alter table public.coursework enable row level security;

create policy "visible education is public" on public.education_records for select using (visible or public.is_cms_admin());
create policy "admins create education" on public.education_records for insert with check (public.is_cms_admin());
create policy "admins update education" on public.education_records for update using (public.is_cms_admin()) with check (public.is_cms_admin());
create policy "admins delete education" on public.education_records for delete using (public.is_cms_admin());
create policy "visible skill groups are public" on public.skill_groups for select using (visible or public.is_cms_admin());
create policy "admins create skill groups" on public.skill_groups for insert with check (public.is_cms_admin());
create policy "admins update skill groups" on public.skill_groups for update using (public.is_cms_admin()) with check (public.is_cms_admin());
create policy "admins delete skill groups" on public.skill_groups for delete using (public.is_cms_admin());
create policy "visible coursework is public" on public.coursework for select using (visible or public.is_cms_admin());
create policy "admins create coursework" on public.coursework for insert with check (public.is_cms_admin());
create policy "admins update coursework" on public.coursework for update using (public.is_cms_admin()) with check (public.is_cms_admin());
create policy "admins delete coursework" on public.coursework for delete using (public.is_cms_admin());

insert into public.education_records (period,title,institution,detail,result,sort_order) values
('JUN 2021 — DEC 2025','BSc in Computer Science & Engineering','East West University, Dhaka','Major in Data Science','CGPA 3.02 / 4.00',1),
('2019','Higher Secondary Certificate (HSC)','Govt. Shah Sultan College, Bogra','Science · Rajshahi Board','GPA 4.25 / 5.00',2),
('2017','Secondary School Certificate (SSC)','APBn Public School and College, Bogra','Science · Rajshahi Board','GPA 5.00 / 5.00',3)
on conflict do nothing;

insert into public.skill_groups (title,skills,sort_order) values
('Programming & data',array['Python','C','C++','SQL','HTML','Pandas','NumPy'],1),
('ML & deep learning',array['TensorFlow','PyTorch','CNNs','classification algorithms'],2),
('Explainable AI',array['Grad-CAM','interpretable computer vision','image processing'],3),
('Analysis & tools',array['Data cleaning','EDA','Matplotlib','Seaborn','LaTeX','Excel'],4)
on conflict (title) do nothing;

insert into public.coursework (title,sort_order) values
('Data Structures & Algorithms',1),('Artificial Intelligence',2),('Machine Learning',3),
('Database Systems',4),('Computer Graphics',5),('Operating Systems',6),
('Computer Networks',7),('Statistics & Probability',8),('Linear Algebra',9)
on conflict (title) do nothing;
